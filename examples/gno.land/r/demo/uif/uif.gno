package uif

import "gno.land/p/demo/uif"

// Render - the main entry point for displaying the home page
func Render(path string) string {
	// Define a custom theme for the page
	customTheme := uif.Theme{
		PrimaryColor:   "#3498db",   // Blue color
		SecondaryColor: "#2ecc71",   // Green color
		FontSize:       "18px",      // Larger font size
		Padding:        "12px 24px", // Custom padding
		BorderRadius:   "10px",      // Rounded corners
	}

	// Navbar with links to different sections
	navbar := uif.Navbar([]string{"Home", "Guide", "Usage"}, customTheme)

	// Heading for the introduction
	headingIntro := uif.Heading(1, "Welcome to the UIF Package Home Page", customTheme)

	// Introduction paragraph
	paragraphIntro := uif.Paragraph(`
		The UIF package offers an easy way to create reusable UI components with a built-in theming system. 
		You can either use the default theme or define your own custom theme for a consistent and flexible UI design. 
		In this guide, you'll learn how to use the package, see examples, and discover how it can simplify UI development.
	`, customTheme)

	// Overview of the sections
	headingOverview := uif.Heading(2, "What's Inside", customTheme)
	paragraphOverview := uif.Paragraph(`
		- The Guide section explains how to use the UIF package and its components.
		- The Usage section shows examples of components with both the default and custom themes.
	`, customTheme)

	// Call-to-action button for exploring the guide
	buttonExplore := uif.Button("Explore the Guide", customTheme)

	// Divider to separate sections
	divider := uif.Divider(customTheme)

	// Footer for the page
	footer := uif.Footer([]string{"Privacy Policy", "Contact", "Terms of Service"}, customTheme)

	// Combine everything to create the introduction home page
	return navbar +
		headingIntro +
		paragraphIntro +
		divider +
		headingOverview +
		paragraphOverview +
		buttonExplore +
		footer
}
