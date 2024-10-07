package uif

import (
	"strconv"
)

// Theme structure and default theme
type Theme struct {
	PrimaryColor   string
	SecondaryColor string
	FontSize       string
	BorderRadius   string
	Padding        string
}

func DefaultTheme() Theme {
	return Theme{
		PrimaryColor:   "#3498db",   // Blue color
		SecondaryColor: "#2ecc71",   // Green color
		FontSize:       "18px",      // Slightly larger font size
		BorderRadius:   "8px",       // More rounded corners
		Padding:        "12px 24px", // Custom padding for better spacing
	}
}

// Theme method for Navbar
func (theme Theme) Navbar(links map[string]string) string {
	nav := `<nav style='background-color: ` + theme.PrimaryColor + `;
padding: 10px;
display: flex;
justify-content: space-around;
align-items: center;
'>`
	for text, href := range links {
		nav += `<a href='` + href + `' style='color: white; text-decoration: none; padding: 10px 15px;'>` + text + `</a>`
	}
	nav += `</nav>`
	return nav
}

// Theme method for Button
func (theme Theme) Button(text, href string) string {
	return "\n" + `<a href='` + href + `' style='
background: linear-gradient(to right, ` + theme.PrimaryColor + `, ` + theme.SecondaryColor + `); /* Gradient */
border: none;
color: white;
padding: ` + theme.Padding + `;
text-align: center;
text-decoration: none;
display: inline-block;
font-size: ` + theme.FontSize + `;
margin-top: 10px;
cursor: pointer;
border-radius: ` + theme.BorderRadius + `;
transition: background 0.3s ease;
'>` + text + `</a>` + "\n"
}

// Theme method for Image with customizable width and height
func (theme Theme) Image(src, width, height string) string {
	// Set default width and height if not provided
	if width == "" {
		width = "100%"
	}
	if height == "" {
		height = "auto"
	}
	return "\n" + `<img src='` + src + `' alt='Sample Image' style='
width: ` + width + `;
height: ` + height + `;
border-radius: ` + theme.BorderRadius + `;
margin-bottom: 15px;
' />` + "\n"
}

// Theme method for Card with customizable width and height
func (theme Theme) Card(content, width, height string) string {
	// Set default width and height if not provided
	if width == "" {
		width = "100%"
	}
	if height == "" {
		height = "auto"
	}
	return "\n" + `<div style='
width: ` + width + `;
height: ` + height + `;
border: 1px solid #ddd;
margin: 20px 0;
border-radius: ` + theme.BorderRadius + `;
padding: ` + theme.Padding + `;
box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
'>` + content + `</div>` + "\n"
}

// Theme method for TextInput
func (theme Theme) TextInput(placeholder string) string {
	return "\n" + `<input type='text' placeholder='` + placeholder + `' style='
width: 100%;
padding: ` + theme.Padding + `;
border-radius: ` + theme.BorderRadius + `;
border: 1px solid #ccc;
font-size: ` + theme.FontSize + `;
margin-bottom: 10px;
'>` + "\n"
}

// Theme method for CodeBlock
func (theme Theme) CodeBlock(code string) string {
	return "\n" + `<pre style='
background-color: #f5f5f5;
color: #333;
padding: ` + theme.Padding + `;
border-radius: ` + theme.BorderRadius + `;
overflow-x: auto;
font-size: ` + theme.FontSize + `;
'><code>` + code + `</code></pre>` + "\n"
}

// Theme method for Grid
func (theme Theme) Grid(items []string, columns int, gap string, textAlign string) string {
	columnsStr := strconv.Itoa(columns)
	grid := `<div style='
display: grid;
grid-template-columns: repeat(` + columnsStr + `, 1fr);
gap: ` + gap + `;
padding: ` + theme.Padding + `;
'>`
	for _, item := range items {
		grid += `<div style='text-align: ` + textAlign + `;'>` + item + `</div>`
	}
	grid += `</div>`
	return grid
}

// Theme method for Footer
func (theme Theme) Footer(links []string) string {
	footer := `<footer style='background-color: ` + theme.SecondaryColor + `;
padding: 10px;
text-align: center;
'>`
	for _, link := range links {
		footer += `<a href='#' style='color: white; text-decoration: none; padding: 10px 15px;'>` + link + `</a>`
	}
	footer += `</footer>`
	return footer
}

// Theme method for Heading
func (theme Theme) Heading(level int, text string) string {
	tag := "h" + strconv.Itoa(level)
	return "\n" + `<` + tag + ` style='
font-size: ` + theme.FontSize + `;
color: ` + theme.PrimaryColor + `;
margin-bottom: 15px;
'>` + text + `</` + tag + `>` + "\n"
}

// Theme method for Paragraph
func (theme Theme) Paragraph(text string) string {
	return "\n" + `<p style='
font-size: ` + theme.FontSize + `;
color: #333;
line-height: 1.6;
margin-bottom: 15px;
'>` + text + `</p>` + "\n"
}

// Theme method for Checkbox

// Theme method for Divider
func (theme Theme) Divider() string {
	return "\n" + `<hr style='
border: 0;
height: 1px;
background: ` + theme.PrimaryColor + `;
margin: 20px 0;
' />` + "\n"
}

// Standalone functions for default theme components

func Navbar(links map[string]string) string {
	var theme Theme = DefaultTheme()
	return theme.Navbar(links)
}

func Button(text, href string) string {
	var theme Theme = DefaultTheme()
	return theme.Button(text, href)
}

func Image(src, width, height string) string {
	var theme Theme = DefaultTheme()
	return theme.Image(src, width, height)
}

func Card(content, width, height string) string {
	var theme Theme = DefaultTheme()
	return theme.Card(content, width, height)
}

func TextInput(placeholder string) string {
	var theme Theme = DefaultTheme()
	return theme.TextInput(placeholder)
}

func CodeBlock(code string) string {
	var theme Theme = DefaultTheme()
	return theme.CodeBlock(code)
}

func Grid(items []string, columns int, gap string, textAlign string) string {
	var theme Theme = DefaultTheme()
	return theme.Grid(items, columns, gap, textAlign)
}

func Footer(links []string) string {
	var theme Theme = DefaultTheme()
	return theme.Footer(links)
}

func Heading(level int, text string) string {
	var theme Theme = DefaultTheme()
	return theme.Heading(level, text)
}

func Paragraph(text string) string {
	var theme Theme = DefaultTheme()
	return theme.Paragraph(text)
}

func Divider() string {
	var theme Theme = DefaultTheme()
	return theme.Divider()
}
