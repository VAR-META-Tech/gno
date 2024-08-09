package gns

import (
	"std"
	"testing"
	"time"

	"gno.land/p/demo/grc/grc721"
	"gno.land/p/demo/testutils"
	"gno.land/p/demo/urequire"
)

var (
	addr1 = testutils.TestAddress("bob")
	addr2 = testutils.TestAddress("alice")
)

func TestSetAndGetMetadata(t *testing.T) {
	registry := NewDomainRegistry("Test Registry", "TST")

	// Create a mock owner address
	owner := addr1

	std.TestSetRealm(std.NewUserRealm(owner))
	std.TestSetOrigCaller(owner)

	metadata := Metadata{
		Avatar:           "avatar_url",
		RegistrationTime: time.Now(),
		ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
		Attributes: []Trait{
			{DisplayType: "string", TraitType: "type", Value: "example"},
		},
		Description: "Test domain",
		ContactInfo: "contact@example.com",
	}

	// Mint a new domain for the owner
	domainName := "test.gno"
	err := registry.domains.Mint(owner, grc721.TokenID(domainName))
	urequire.NoError(t, err)

	// Set metadata for the domain
	err = registry.SetDomainData(domainName, metadata)
	urequire.NoError(t, err)

	// Retrieve the metadata
	retrievedMetadata, err := registry.GetDomainData(domainName, FieldAvatar)
	urequire.NoError(t, err)
	urequire.Equal(t, metadata.Avatar, retrievedMetadata.Avatar)
}

func TestSetMetadata_NotOwner(t *testing.T) {
	registry := NewDomainRegistry("Test Registry", "TST")

	// Create a mock owner and non-owner address
	owner := addr1
	nonOwner := addr2

	metadata := Metadata{
		Avatar:           "avatar_url",
		RegistrationTime: time.Now(),
		ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
		Attributes: []Trait{
			{DisplayType: "string", TraitType: "type", Value: "example"},
		},
		Description: "Test domain",
		ContactInfo: "contact@example.com",
	}

	// Mint a new domain for the owner
	domainName := "test.gno"
	err := registry.domains.Mint(owner, grc721.TokenID(domainName))
	urequire.NoError(t, err)

	// Try to set metadata for the domain as a non-owner
	std.TestSetRealm(std.NewUserRealm(nonOwner))
	std.TestSetOrigCaller(nonOwner)

	err = registry.SetDomainData(domainName, metadata)
	urequire.Error(t, err)
	urequire.Equal(t, err.Error(), ErrUnauthorized.Error())
}

func TestGetMetadata_InvalidDomain(t *testing.T) {
	registry := NewDomainRegistry("Test Registry", "TST")

	// Try to get metadata for a domain that doesn't exist
	domainName := "nonexistent.gno"
	_, err := registry.GetDomainFields(domainName, []MetadataField{})
	urequire.Error(t, err)
	urequire.Equal(t, err.Error(), ErrInvalidDomainName.Error())
}

func TestRenewDomain_Success(t *testing.T) {
	registry := NewDomainRegistry("Test Registry", "TST")

	// Create a mock owner address
	owner := addr1

	std.TestSetRealm(std.NewUserRealm(owner))
	std.TestSetOrigCaller(owner)

	metadata := Metadata{
		Avatar:           "avatar_url",
		RegistrationTime: time.Now(),
		ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
		Attributes: []Trait{
			{DisplayType: "string", TraitType: "type", Value: "example"},
		},
		Description: "Test domain",
		ContactInfo: "contact@example.com",
	}

	// Mint a new domain for the owner
	domainName := "renewable.gno"
	err := registry.domains.Mint(owner, grc721.TokenID(domainName))
	urequire.NoError(t, err)

	// Set metadata for the domain
	err = registry.SetDomainData(domainName, metadata)
	urequire.NoError(t, err)

	// Renew the domain
	additionalDuration := 30 * 24 * time.Hour
	err = registry.RenewDomain(domainName, additionalDuration)
	urequire.NoError(t, err)

	// Check that the expiration was extended
	renewedMetadata, err := registry.GetDomainData(domainName, FieldExpirationTime)
	urequire.NoError(t, err)
	expectedExpirationTime := metadata.ExpirationTime
	urequire.Equal(t, expectedExpirationTime.Unix(), renewedMetadata.ExpirationTime.Unix())
}
