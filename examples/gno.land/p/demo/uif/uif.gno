package uif

// Theme structure and default theme
type Theme struct {
	PrimaryColor   string
	SecondaryColor string
	FontSize       string
	BorderRadius   string
	Padding        string
}

// DefaultTheme returns the default theme for components
func DefaultTheme() Theme {
	return Theme{
		PrimaryColor:   "#f6d365",
		SecondaryColor: "#fda085",
		FontSize:       "16px",
		BorderRadius:   "5px",
		Padding:        "10px 20px",
	}
}

// Button component with variadic theme
func Button(text string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	return "\n" + `<a href='#' style='
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
'>
` + text +
		`</a>` + "\n"
}

// Image component with variadic theme
func Image(src string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	return "\n" + `<img src='` + src + `' alt='Sample Image' style='
	                width: 100%;
	                border-radius: ` + theme.BorderRadius + `;
	                margin-bottom: 15px;
	            ' />` + "\n"
}

// Card component with variadic theme
func Card(content string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	return "\n" + `<div style='
border: 1px solid #ddd;
border-radius: ` + theme.BorderRadius + `;
padding: ` + theme.Padding + `;
box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
'>
` + content +
		`</div>` + "\n"
}

// TextInput component with variadic theme
func TextInput(placeholder string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	return "\n" + `<input type='text' placeholder='` + placeholder + `' style='
width: 100%;
padding: ` + theme.Padding + `;
border-radius: ` + theme.BorderRadius + `;
border: 1px solid #ccc;
font-size: ` + theme.FontSize + `;
margin-bottom: 10px;
'>
` + "\n"
}

// Navbar component with variadic theme
func Navbar(links []string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	nav := `<nav style='background-color: ` + theme.PrimaryColor + `;
padding: 10px;
display: flex;
justify-content: space-around;
align-items: center;
'>
`
	for _, link := range links {
		nav += `<a href='#' style='color: white; text-decoration: none; padding: 10px 15px;'>` + link + `</a>`
	}

	nav += `</nav>`
	return nav
}

// New Footer component
func Footer(links []string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	footer := `<footer style='background-color: ` + theme.SecondaryColor + `;
padding: 10px;
text-align: center;
'>
`
	for _, link := range links {
		footer += `<a href='#' style='color: white; text-decoration: none; padding: 10px 15px;'>` + link + `</a>`
	}

	footer += `</footer>`
	return footer
}

// Heading component with variadic theme
func Heading(level int, text string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	tag := "h" + string(level+'0')
	return "\n" + `<` + tag + ` style='
font-size: ` + theme.FontSize + `;
color: ` + theme.PrimaryColor + `;
margin-bottom: 15px;
'>
` + text + `</` + tag + `>` + "\n"
}

// Paragraph component with variadic theme
func Paragraph(text string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	return "\n" + `<p style='
font-size: ` + theme.FontSize + `;
color: #333;
line-height: 1.6;
margin-bottom: 15px;
'>` + text + `</p>` + "\n"
}

// Checkbox component
func Checkbox(label string, params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	return "\n" + `<label style='font-size: ` + theme.FontSize + `;'>
<input type='checkbox' style='margin-right: 10px;'>` + label + `
</label>` + "\n"
}

// Divider component
func Divider(params ...Theme) string {
	var theme Theme
	if len(params) > 0 {
		theme = params[0]
	} else {
		theme = DefaultTheme()
	}

	return "\n" + `<hr style='
border: 0;
height: 1px;
background: ` + theme.PrimaryColor + `;
margin: 20px 0;
' />` + "\n"
}
