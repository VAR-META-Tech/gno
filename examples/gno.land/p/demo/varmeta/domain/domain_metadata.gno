package domain

import (
	"time"
)

// Trait represents a key-value pair with an optional display type for metadata attributes
type Trait struct {
	DisplayType string // Optional display type (e.g., "date", "number", etc.)
	TraitType   string // Type of the trait (e.g., "age", "height", etc.)
	Value       string // Value of the trait
}

// Metadata represents the metadata associated with a domain
type Metadata struct {
	Avatar           string    // URL or identifier for an avatar image
	RegistrationTime time.Time // The time when the domain was registered
	ExpirationTime   time.Time // The time when the domain will be expire
	Attributes       []Trait   // Additional attributes of the domain
	Description      string    // A description of the domain
	ContactInfo      string    // Contact information for the domain owner
	RenewalFee       string    // The fee required to renew the domain, represented as a string
}

// NewMetadata creates a new Metadata instance
func NewMetadata(avatar, description, contactInfo, renewalFee string,
	registrationTime, expirationTime time.Time, attributes []Trait,
) Metadata {
	return Metadata{
		Avatar:           avatar,
		RegistrationTime: registrationTime,
		ExpirationTime:   expirationTime,
		RenewalFee:       renewalFee,
		Attributes:       attributes,
		Description:      description,
		ContactInfo:      contactInfo,
	}
}
