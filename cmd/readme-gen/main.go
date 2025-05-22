package main

import (
	"bufio"
	"bytes"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
	"sync"

	"golang.org/x/tools/go/packages"
)

var (
	targetDirs   []string
	verbose      bool
	outputFile   string
	excludeDirs  []string
	includeTests bool
	workers      int
)

func init() {
	flag.Var((*stringSlice)(&targetDirs), "dir", "Directory to scan (can be specified multiple times)")
	flag.BoolVar(&verbose, "verbose", false, "Enable verbose logging")
	flag.StringVar(&outputFile, "output", "", "Output file path (default: README.md in each scanned directory)")
	flag.Var((*stringSlice)(&excludeDirs), "exclude", "Directories to exclude (can be specified multiple times)")
	flag.BoolVar(&includeTests, "include-tests", false, "Include test packages in the output")
	flag.IntVar(&workers, "workers", 4, "Number of parallel workers")
}

type stringSlice []string

func (s *stringSlice) String() string {
	return strings.Join(*s, ",")
}

func (s *stringSlice) Set(value string) error {
	*s = append(*s, value)
	return nil
}

func main() {
	flag.Parse()
	if len(targetDirs) == 0 {
		targetDirs = []string{"./gnovm", "./tm2", "./gno.land"}
	}
	type result struct {
		dir      string
		markdown string
		err      error
	}
	results := make(chan result)
	var wg sync.WaitGroup
	for _, dir := range targetDirs {
		dir = strings.TrimSpace(dir)
		if dir == "" {
			continue
		}
		if isExcluded(dir) {
			if verbose {
				fmt.Printf("Skipping excluded directory: %s\n", dir)
			}
			continue
		}
		wg.Add(1)
		go func(dir string) {
			defer wg.Done()
			absDir, err := filepath.Abs(dir)
			if err != nil {
				results <- result{dir, "", err}
				return
			}
			if verbose {
				fmt.Printf("Scanning directory: %s\n", absDir)
			}
			pkgs, err := loadPackages(absDir)
			if err != nil {
				results <- result{dir, "", err}
				return
			}
			if verbose {
				fmt.Printf("Found %d packages in %s\n", len(pkgs), absDir)
			}
			markdown := generateMarkdown(absDir, pkgs)
			results <- result{dir, markdown, nil}
		}(dir)
	}
	go func() {
		wg.Wait()
		close(results)
	}()
	for r := range results {
		if r.err != nil {
			fmt.Printf("Error processing %s: %v\n", r.dir, r.err)
			continue
		}
		readmePath := outputFile
		if readmePath == "" {
			readmePath = filepath.Join(r.dir, "README.md")
		}
		if err := writeReadme(readmePath, r.markdown); err != nil {
			fmt.Printf("Error writing README in %s: %v\n", r.dir, err)
			continue
		}
		if verbose {
			fmt.Printf("Successfully updated README at: %s\n", readmePath)
		}
	}
}

func isExcluded(dir string) bool {
	for _, excludeDir := range excludeDirs {
		if strings.Contains(dir, excludeDir) {
			return true
		}
	}
	return false
}

func loadPackages(dir string) ([]*packages.Package, error) {
	cfg := &packages.Config{
		Mode:  packages.NeedName | packages.NeedFiles,
		Tests: includeTests,
	}
	pkgs, err := packages.Load(cfg, dir+"/...")
	if err != nil {
		return nil, err
	}
	var gnoPkgs []*packages.Package
	for _, pkg := range pkgs {
		gnoFiles := []string{}
		for _, f := range pkg.GoFiles {
			if strings.HasSuffix(f, ".go") || strings.HasSuffix(f, ".gno") {
				gnoFiles = append(gnoFiles, f)
			}
		}
		if len(gnoFiles) > 0 {
			pkg.GoFiles = gnoFiles
			gnoPkgs = append(gnoPkgs, pkg)
		}
	}
	return gnoPkgs, nil
}

func generateMarkdown(dir string, pkgs []*packages.Package) string {
	var content strings.Builder
	content.WriteString("<!-- BEGIN GENERATED PACKAGE LIST -->\n\n")
	dirMap := make(map[string][]*packages.Package)
	for _, pkg := range pkgs {
		if len(pkg.GoFiles) == 0 {
			continue
		}
		relPath := strings.TrimPrefix(pkg.PkgPath, strings.TrimPrefix(dir, "./"))
		relPath = strings.TrimPrefix(relPath, "/")
		parts := strings.Split(relPath, "/")
		if len(parts) == 0 {
			continue
		}
		topDir := parts[0]
		dirMap[topDir] = append(dirMap[topDir], pkg)
	}
	dirs := make([]string, 0, len(dirMap))
	for dir := range dirMap {
		dirs = append(dirs, dir)
	}
	sort.Strings(dirs)
	for _, topDir := range dirs {
		content.WriteString(fmt.Sprintf("* [%s](./%s)\n", topDir, topDir))
		pkgs := dirMap[topDir]
		sort.Slice(pkgs, func(i, j int) bool {
			return pkgs[i].PkgPath < pkgs[j].PkgPath
		})
		for _, pkg := range pkgs {
			doc := getOneLineDoc(pkg)
			relPath := strings.TrimPrefix(pkg.PkgPath, strings.TrimPrefix(dir, "./"))
			relPath = strings.TrimPrefix(relPath, "/")
			content.WriteString(fmt.Sprintf("  * [%s](./%s) - %s\n", relPath, relPath, doc))
		}
	}
	content.WriteString("\n<!-- END GENERATED PACKAGE LIST -->")
	return content.String()
}

func getOneLineDoc(pkg *packages.Package) string {
	if verbose {
		fmt.Printf("Searching for package doc in files: %v\n", pkg.GoFiles)
	}
	// First try to find documentation in .go and .gno files
	for _, file := range pkg.GoFiles {
		if verbose {
			fmt.Printf("Reading file: %s\n", file)
		}
		data, err := os.ReadFile(file)
		if err != nil {
			if verbose {
				fmt.Printf("Warning: Failed to read %s: %v\n", file, err)
			}
			continue
		}
		lines := strings.Split(string(data), "\n")
		for _, line := range lines {
			line = strings.TrimSpace(line)
			if strings.HasPrefix(line, "// Package ") {
				if verbose {
					fmt.Printf("Found package doc in %s: %s\n", file, line)
				}
				return strings.TrimPrefix(line, "// Package "+pkg.Name+" ")
			}
		}
	}

	// If no documentation found in files, try go doc
	if verbose {
		fmt.Printf("No package doc found in files, trying go doc for %s\n", pkg.PkgPath)
	}
	cmd := exec.Command("go", "doc", "-short", pkg.PkgPath)
	output, err := cmd.CombinedOutput()
	if err != nil {
		if verbose {
			fmt.Printf("Warning: Failed to get doc for %s: %v\n", pkg.PkgPath, err)
		}
		return fmt.Sprintf("Package %s has no documentation", pkg.Name)
	}

	scanner := bufio.NewScanner(bytes.NewReader(output))
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if strings.HasPrefix(line, "Package ") {
			doc := strings.TrimPrefix(line, "Package "+pkg.Name+" ")
			doc = strings.TrimSpace(doc)
			if doc != "" {
				if verbose {
					fmt.Printf("Found package doc from go doc: %s\n", doc)
				}
				return doc
			}
		}
	}
	return fmt.Sprintf("Package %s has no documentation", pkg.Name)
}

func writeReadme(readmePath, newContent string) error {
	if verbose {
		fmt.Printf("Writing to README at: %s\n", readmePath)
	}

	// Đọc nội dung hiện tại của file
	existingContent := ""
	if data, err := os.ReadFile(readmePath); err == nil {
		existingContent = string(data)
	}

	// Tìm vị trí của các marker
	startMarker := "<!-- BEGIN GENERATED PACKAGE LIST -->"
	endMarker := "<!-- END GENERATED PACKAGE LIST -->"
	startIdx := strings.Index(existingContent, startMarker)
	endIdx := strings.Index(existingContent, endMarker)

	var finalContent string
	if startIdx >= 0 && endIdx > startIdx {
		// Nếu đã có marker, thay thế nội dung giữa chúng
		finalContent = existingContent[:startIdx] + newContent + existingContent[endIdx+len(endMarker):]
	} else {
		// Nếu chưa có marker, thêm vào cuối file
		if existingContent != "" && !strings.HasSuffix(existingContent, "\n") {
			existingContent += "\n"
		}
		finalContent = existingContent + newContent
	}

	// Ghi nội dung vào file
	return os.WriteFile(readmePath, []byte(finalContent), 0644)
}
