package mdui

import (
	"strings"

	"gno.land/p/demo/mdui"
)

// RenderHomePage - Renders the Home page with a new introduction and updated sections
func RenderHomePage() string {
	// Navbar with links and href values using the new Markdown approach
	navbarLinks := map[string]string{
		"Home":          "/r/demo/mdui",
		"Components":    "/r/demo/mdui:components",
		"Documentation": "/r/demo/mdui:documentation",
		"Get Started":   "/r/demo/mdui:get-started",
	}
	navbar := mdui.Navbar(navbarLinks)

	// Heading for the introduction
	headingIntro := mdui.Heading(1, "Welcome to mdui - Your UI Framework Solution")

	// Introduction paragraph with new content
	paragraphIntro := mdui.Paragraph(`
mdui is a flexible and powerful UI framework designed to help developers create stunning user interfaces with ease.
Our package comes with a variety of reusable components, theme customization options, and comprehensive documentation.
Whether you're building a small app or a complex web project, mdui has the tools to simplify the process and enhance your workflow.
Join our growing community of developers and start crafting beautiful interfaces today.
`)

	// Call-to-action button for learning more
	buttonLearnMore := mdui.Button("Learn More", "/r/demo/mdui:components")

	// Divider to separate sections
	divider := mdui.Divider()

	// Organize content using Markdown
	content := navbar + "\n" +
		headingIntro + "\n" +
		paragraphIntro + "\n" +
		divider + "\n" +
		buttonLearnMore + "\n"

	return content
}

// RenderComponentsPage - Renders the Components page with a list of available components, examples, and sample code
func RenderComponentsPage() string {
	// Navbar with updated links
	navbarLinks := map[string]string{
		"Home":          "/r/demo/mdui",
		"Components":    "/r/demo/mdui:components",
		"Documentation": "/r/demo/mdui:documentation",
		"Get Started":   "/r/demo/mdui:get-started",
	}
	navbar := mdui.Navbar(navbarLinks)

	// Main title and introduction
	headingMain := mdui.Heading(1, "mdui Components Overview")
	descriptionMain := mdui.Paragraph(`
mdui offers a variety of components that help developers build modern user interfaces quickly and efficiently.
Below is a list of components available in the mdui package, along with examples of how to use them and sample code.
`)

	// List of components with descriptions, examples, and sample code
	componentList := []struct {
		Title       string
		Description string
		Example     string
		SampleCode  string
	}{
		{
			Title:       "Navbar",
			Description: "A navigation menu that can be used to create a list of links for site navigation.",
			Example:     mdui.Navbar(map[string]string{"Home": "/home", "About": "/about", "Contact": "/contact"}),
			SampleCode:  `mdui.Navbar(map[string]string{"Home": "/home", "About": "/about", "Contact": "/contact"})`,
		},
		{
			Title:       "Heading",
			Description: "A heading component to create titles of different levels (from H1 to H6).",
			Example:     mdui.Heading(2, "Sample Heading"),
			SampleCode:  `mdui.Heading(2, "Sample Heading")`,
		},
		{
			Title:       "Button",
			Description: "A clickable button component, implemented as a link in Markdown.",
			Example:     mdui.Button("Click Here", "/click-here"),
			SampleCode:  `mdui.Button("Click Here", "/click-here")`,
		},
		{
			Title:       "Link",
			Description: "A simple link component to create hyperlinks.",
			Example:     mdui.Link("Visit our website", "https://example.com"),
			SampleCode:  `mdui.Link("Visit our website", "https://example.com")`,
		},
		{
			Title:       "Image",
			Description: "An image component for displaying pictures with optional alt text.",
			Example:     mdui.Image("https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp", "Sample Image"),
			SampleCode:  `mdui.Image("https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp", "Sample Image")`,
		},
		{
			Title:       "CodeBlock",
			Description: "A component for rendering code blocks in Markdown.",
			Example:     mdui.CodeBlock("func main() {\n    fmt.Println(\"Hello, world!\")\n}"),
			SampleCode:  `mdui.CodeBlock("func main() {\n    fmt.Println(\"Hello, world!\")\n}")`,
		},
		{
			Title:       "Divider",
			Description: "A horizontal line divider for separating content.",
			Example:     mdui.Divider(),
			SampleCode:  `mdui.Divider()`,
		},
		{
			Title:       "Paragraph",
			Description: "Formats a block of text as a paragraph.",
			Example:     mdui.Paragraph("This is a sample paragraph."),
			SampleCode:  `mdui.Paragraph("This is a sample paragraph.")`,
		},
		{
			Title:       "Quote",
			Description: "A blockquote component for highlighting quoted text.",
			Example:     mdui.Quote("This is a quoted text."),
			SampleCode:  `mdui.Quote("This is a quoted text.")`,
		},
		{
			Title:       "List (Unordered)",
			Description: "Generates an unordered Markdown list.",
			Example:     mdui.List([]string{"Item 1", "Item 2", "Item 3"}, false),
			SampleCode:  `mdui.List([]string{"Item 1", "Item 2", "Item 3"}, false)`,
		},
		{
			Title:       "List (Ordered)",
			Description: "Generates an ordered Markdown list.",
			Example:     mdui.List([]string{"Step 1", "Step 2", "Step 3"}, true),
			SampleCode:  `mdui.List([]string{"Step 1", "Step 2", "Step 3"}, true)`,
		},
		{
			Title:       "Table",
			Description: "Generates a table with headers and rows for tabular data.",
			Example:     mdui.Table([]string{"Name", "Age"}, [][]string{{"Alice", "30"}, {"Bob", "25"}}),
			SampleCode:  `mdui.Table([]string{"Name", "Age"}, [][]string{{"Alice", "30"}, {"Bob", "25"}})`,
		},
		{
			Title:       "Bold",
			Description: "Formats text in bold.",
			Example:     mdui.Bold("This is bold text"),
			SampleCode:  `mdui.Bold("This is bold text")`,
		},
		{
			Title:       "Italic",
			Description: "Formats text in italic.",
			Example:     mdui.Italic("This is italic text"),
			SampleCode:  `mdui.Italic("This is italic text")`,
		},
		{
			Title:       "Strikethrough",
			Description: "Adds a strikethrough to the text.",
			Example:     mdui.Strikethrough("This text is crossed out"),
			SampleCode:  `mdui.Strikethrough("This text is crossed out")`,
		},
		{
			Title:       "TaskList",
			Description: "A list of tasks with checkboxes, indicating completion status.",
			Example:     mdui.TaskList(map[string]bool{"Task 1": true, "Task 2": false}),
			SampleCode:  `mdui.TaskList(map[string]bool{"Task 1": true, "Task 2": false})`,
		},
	}

	// Generate Markdown for each component
	componentMarkdown := ""
	for _, component := range componentList {
		componentMarkdown += mdui.Heading(2, component.Title) + "\n"
		componentMarkdown += mdui.Paragraph(component.Description) + "\n"
		componentMarkdown += mdui.Paragraph("**Rendered Example:**") + "\n"
		componentMarkdown += component.Example + "\n\n"
		componentMarkdown += mdui.Paragraph("**Sample Code:**") + "\n"
		componentMarkdown += mdui.CodeBlock(component.SampleCode) + "\n"
		componentMarkdown += mdui.Divider() + "\n"
	}

	// Combine everything into the components page
	return navbar + "\n" +
		headingMain + "\n" +
		descriptionMain + "\n" +
		componentMarkdown
}

// Render - The main entry point for displaying different pages
func Render(path string) string {
	segments := strings.Split(path, "/")

	switch segments[0] {
	case "components":
		return RenderComponentsPage()
	default:
		return RenderHomePage()
	}
}
