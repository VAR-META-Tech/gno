package domain

import (
	"strings"

	"gno.land/p/demo/mdui"
)

// RenderBiddingListPage - Renders a page listing domains available for bidding
func RenderBiddingListPage() string {
	builder := mdui.NewMarkdownBuilder()

	// Navbar with links to different sections
	navbarLinks := map[string]string{
		"Home":          "/r/varmeta/domain",
		"Bidding Board": "/r/varmeta/domain:bidding-list",
	}
	builder.AddNavbar(navbarLinks)

	// Title and introduction
	builder.AddHeading(1, " Bidding Domains").
		AddParagraph(`
Browse the list of domains currently open for bidding. Each domain has relevant details, including the current bid status and a button to place your bid.
Participate in secure, fair, and confidential bidding for the domains listed below.
`).
		AddDivider()

	// "Start New Bidding" button
	builder.AddBreakLine()

	builder.AddButton("Start New Bidding", "https://gno.studio/connect/view/gno.land/r/varmeta/demo/v7/domain/registrar?network=test4#CommitHash").
		AddDivider()

	// Sample list of domains for demonstration
	domains := []struct {
		Name    string
		Status  string
		Winner  string
		BidLink string
	}{
		{"example.com", "Commit Hash Phase", "", "https://gno.studio/connect/view/gno.land/r/varmeta/demo/v7/domain/registrar?network=test4#CommitHash"},
		{"mydomain.org", "Commit Price Phase", "", "https://gno.studio/connect/view/gno.land/r/varmeta/demo/v7/domain/registrar?network=test4#CommitPrice"},
		{"business.net", "Claiming", "", "https://gno.studio/connect/view/gno.land/r/varmeta/demo/v7/domain/registrar?network=test4#Claim"},
		{"techworld.co", "Bidding Closed", "", ""},
	}

	// Generate Markdown for each domain
	for _, domain := range domains {
		builder.AddHeading(2, domain.Name).
			AddParagraph("Status: " + domain.Status)

		// Only add a "Place Bid" button if bidding is open
		if domain.BidLink != "" {
			if domain.Status == "Commit Hash Phase" {
				builder.AddButton("Commit Hash", domain.BidLink)
			} else if domain.Status == "Commit Price Phase" {
				builder.AddButton("Commit Price", domain.BidLink)
			} else if domain.Status == "Claiming" {
				builder.AddParagraph("Winner: " + domain.Winner)
				builder.AddButton("Claim", domain.BidLink)
			} else {
				builder.AddParagraph("Winner: " + domain.Winner)
			}
		}
		builder.AddBreakLine()
		builder.AddDivider()
	}

	return builder.Render()
}

func RenderSealedBiddingHomePage() string {
	// Navbar with links to different sections
	navbarLinks := map[string]string{
		"Home":         "/r/varmeta/domain",
		"Bidding List": "/r/varmeta/domain:bidding-list",
	}
	navbar := mdui.Navbar(navbarLinks)

	// Main title and introduction
	headingIntro := mdui.Heading(1, "Welcome to the Sealed Bidding Package")

	// Introduction paragraph
	paragraphIntro := mdui.Paragraph(`
The Sealed Bidding package is a comprehensive solution for conducting secure and transparent sealed bid auctions.
This package simplifies the bidding process by enabling participants to submit their bids confidentially, ensuring fairness and competition in the auction process.
Whether you're organizing procurement, real estate, or government auctions, this package provides all the essential tools to get started.
`)

	// Getting Started section with a call-to-action button
	headingGettingStarted := mdui.Heading(2, "Getting Started with Sealed Bidding")
	paragraphGettingStarted := mdui.Paragraph(`
Ready to use the Sealed Bidding package? Follow these steps to implement sealed bidding in your application:
1. [Learn How It Works](/r/demo/sealedbid:how-it-works) - Understand the principles and workflow of sealed bidding.
2. [Explore Examples](/r/demo/sealedbid:examples) - See practical examples of how sealed bidding can be applied.
3. [FAQ](/r/demo/sealedbid:faq) - Get answers to frequently asked questions.
`)
	buttonGetStarted := mdui.Button("Start Using Sealed Bidding", "/r/demo/sealedbid:how-it-works")

	// Benefits section
	benefitsHeading := mdui.Heading(2, "Why Choose Sealed Bidding?")
	benefitsList := mdui.List([]string{
		"Ensures confidentiality and fairness in the bidding process.",
		"Prevents collusion and price manipulation among participants.",
		"Enables efficient, transparent, and secure auctions.",
		"Adaptable to various types of auctions, including procurement and asset sales.",
	}, false)

	// How It Works section
	howItWorksHeading := mdui.Heading(2, "How Sealed Bidding Works")
	howItWorksParagraph := mdui.Paragraph(`
In a sealed bid auction, all participants submit their bids in secret, without knowing the bids of others.
The bids are only revealed once the bidding period has ended. The highest bid (or the most suitable offer, depending on the criteria) wins.
This method is often used in procurement, real estate auctions, and government contracts to ensure fairness and competition.
`)
	buttonLearnMore := mdui.Button("Learn More About Sealed Bidding", "/r/demo/sealedbid:how-it-works")

	// Divider to separate sections
	divider := mdui.Divider()

	// Conclusion
	conclusionHeading := mdui.Heading(2, "Conclusion")
	conclusionParagraph := mdui.Paragraph(`
Sealed bidding is an essential mechanism for conducting fair and competitive auctions. Our Sealed Bidding package provides a user-friendly, secure solution to streamline the bidding process. Explore more to see how it can benefit your organization.
`)

	// Organize the content
	content := navbar + "\n" +
		headingIntro + "\n" +
		paragraphIntro + "\n" +
		divider + "\n" +
		headingGettingStarted + "\n" +
		paragraphGettingStarted + "\n" +
		buttonGetStarted + "\n\n" +
		divider + "\n" +
		benefitsHeading + "\n" +
		benefitsList + "\n" +
		divider + "\n" +
		howItWorksHeading + "\n" +
		howItWorksParagraph + "\n" +
		buttonLearnMore + "\n" +
		divider + "\n" +
		conclusionHeading + "\n" +
		conclusionParagraph + "\n"

	return content
}

func Render(path string) string {
	switch {
	case strings.Contains(path, "bidding-list"):
		return RenderBiddingListPage()
	default:
		return RenderSealedBiddingHomePage()
	}
}
