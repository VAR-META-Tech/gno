package domain

import (
	"std"
	"testing"
	"time"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/urequire"
	"gno.land/p/varmeta/demo/v7/grc/grc721"
)

var (
	addr1 = testutils.TestAddress("bob")
	addr2 = testutils.TestAddress("alice")
)

func TestRegisterDomain(t *testing.T) {
	registry := NewDomainRegistry("GNO Name Service", "GNS")

	cases := []struct {
		name        string
		owner       std.Address
		domainName  string
		metadata    Metadata
		expectError bool
	}{
		{
			name:       "Successful Registration",
			owner:      addr1,
			domainName: "registered.gno",
			metadata: Metadata{
				Avatar:           "avatar_url",
				RegistrationTime: time.Now(),
				ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
				Description:      "A registered domain",
				ContactInfo:      "contact@registered.com",
			},
			expectError: false,
		},
		{
			name:       "Duplicate Registration",
			owner:      addr1,
			domainName: "registered.gno",
			metadata: Metadata{
				Avatar:           "avatar_url",
				RegistrationTime: time.Now(),
				ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
				Description:      "A registered domain",
				ContactInfo:      "gno_name_service@gno.land",
			},
			expectError: true,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			std.TestSetRealm(std.NewUserRealm(c.owner))
			std.TestSetOrigCaller(c.owner)

			err := registry.RegisterDomain(c.owner, c.domainName, c.metadata)
			if c.expectError {
				urequire.Error(t, err)
			} else {
				urequire.NoError(t, err)

				retrievedOwner, err := registry.OwnerOf(c.domainName)
				urequire.NoError(t, err)
				urequire.Equal(t, c.owner, retrievedOwner)
			}
		})
	}
}

func TestSetDomainData(t *testing.T) {
	registry := NewDomainRegistry("GNO Name Service", "GNS")

	cases := []struct {
		name        string
		owner       std.Address
		caller      std.Address
		domainName  string
		metadata    Metadata
		expectError bool
	}{
		{
			name:       "Owner Sets Metadata",
			owner:      addr1,
			caller:     addr1,
			domainName: "test.gno",
			metadata: Metadata{
				Avatar:           "avatar_url",
				RegistrationTime: time.Now(),
				ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
				Description:      "A test domain",
				ContactInfo:      "gno_name_service@gno.land",
			},
			expectError: false,
		},
		{
			name:       "Non-Owner Sets Metadata",
			owner:      addr1,
			caller:     addr2,
			domainName: "test.gno",
			metadata: Metadata{
				Avatar:           "avatar_url",
				RegistrationTime: time.Now(),
				ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
				Description:      "A test domain",
				ContactInfo:      "gno_name_service@gno.land",
			},
			expectError: true,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			std.TestSetRealm(std.NewUserRealm(c.owner))
			std.TestSetOrigCaller(c.owner)
			registry.RegisterDomain(c.owner, c.domainName, c.metadata)

			std.TestSetRealm(std.NewUserRealm(c.caller))
			std.TestSetOrigCaller(c.caller)
			err := registry.SetDomainData(c.domainName, c.metadata)

			if c.expectError {
				urequire.Error(t, err)
				urequire.Equal(t, err.Error(), ErrUnauthorized.Error())
			} else {
				urequire.NoError(t, err)
				retrievedMetadata, err := registry.GetDomainData(c.domainName, FieldAvatar)
				urequire.NoError(t, err)
				urequire.Equal(t, c.metadata.Avatar, retrievedMetadata.Avatar)
			}
		})
	}
}

func TestRenewDomain(t *testing.T) {
	registry := NewDomainRegistry("GNO Name Service", "GNS")

	cases := []struct {
		name           string
		owner          std.Address
		caller         std.Address
		domainName     string
		additionalTime time.Duration
		expectError    bool
		expectedExpiry time.Time
	}{
		{
			name:           "Successful Renewal",
			owner:          addr1,
			caller:         addr1,
			domainName:     "renewable.gno",
			additionalTime: 30 * 24 * time.Hour,
			expectError:    false,
		},
		{
			name:           "Non-Owner Attempts Renewal",
			owner:          addr1,
			caller:         addr2,
			domainName:     "renewable.gno",
			additionalTime: 30 * 24 * time.Hour,
			expectError:    true,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			std.TestSetRealm(std.NewUserRealm(c.owner))
			std.TestSetOrigCaller(c.owner)

			metadata := Metadata{
				Avatar:           "avatar_url",
				RegistrationTime: time.Now(),
				ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
				Description:      "A renewable domain",
				ContactInfo:      "gno_name_service@gno.land",
			}

			registry.RegisterDomain(c.owner, c.domainName, metadata)

			std.TestSetRealm(std.NewUserRealm(c.caller))
			std.TestSetOrigCaller(c.caller)

			err := registry.RenewDomain(c.domainName, c.additionalTime)
			if c.expectError {
				urequire.Error(t, err)
				urequire.Equal(t, err.Error(), ErrUnauthorized.Error())
			} else {
				urequire.NoError(t, err)
				renewedMetadata, err := registry.GetDomainData(c.domainName, FieldExpirationTime)
				urequire.NoError(t, err)
				// urequire.True(t, renewedMetadata.ExpirationTime.After(metadata.ExpirationTime))
			}
		})
	}
}

func TestGetDomainData(t *testing.T) {
	registry := NewDomainRegistry("GNO Name Service", "GNS")

	cases := []struct {
		name        string
		domainName  string
		field       MetadataField
		expectError bool
		expectedVal string
	}{
		{
			name:        "Retrieve Avatar",
			domainName:  "test.gno",
			field:       FieldAvatar,
			expectError: false,
			expectedVal: "avatar_url",
		},
		{
			name:        "Invalid Domain Name",
			domainName:  "invalid.gno",
			field:       FieldAvatar,
			expectError: true,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			if !c.expectError {
				owner := addr1
				std.TestSetRealm(std.NewUserRealm(owner))
				std.TestSetOrigCaller(owner)

				metadata := Metadata{
					Avatar:           "avatar_url",
					RegistrationTime: time.Now(),
					ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
					Description:      "A test domain",
					ContactInfo:      "gno_name_service@gno.land",
				}

				err := registry.RegisterDomain(owner, c.domainName, metadata)
				urequire.NoError(t, err)
			}

			_, err := registry.GetDomainData(c.domainName, c.field)
			if c.expectError {
				urequire.Error(t, err)
				urequire.Equal(t, err.Error(), ErrInvalidDomainName.Error())
			} else {
				urequire.NoError(t, err)
			}
		})
	}
}

func TestGetDomainFields(t *testing.T) {
	registry := NewDomainRegistry("GNO Name Service", "GNS")

	cases := []struct {
		name        string
		domainName  string
		fields      []MetadataField
		expectError bool
		expected    Metadata
	}{
		{
			name:        "Retrieve Multiple Fields",
			domainName:  "test.gno",
			fields:      []MetadataField{FieldAvatar, FieldDescription, FieldContactInfo},
			expectError: false,
			expected: Metadata{
				Avatar:      "avatar_url",
				Description: "A test domain",
				ContactInfo: "gno_name_service@gno.land",
			},
		},
		{
			name:        "Invalid Domain",
			domainName:  "invalid.gno",
			fields:      []MetadataField{FieldAvatar},
			expectError: true,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			if !c.expectError {
				owner := addr1
				std.TestSetRealm(std.NewUserRealm(owner))
				std.TestSetOrigCaller(owner)

				metadata := Metadata{
					Avatar:           "avatar_url",
					RegistrationTime: time.Now(),
					ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
					Description:      "A test domain",
					ContactInfo:      "gno_name_service@gno.land",
				}

				err := registry.RegisterDomain(owner, c.domainName, metadata)
				urequire.NoError(t, err)
			}

			retrievedMetadata, err := registry.GetDomainFields(c.domainName, c.fields)
			if c.expectError {
				urequire.Error(t, err)
				urequire.Equal(t, err.Error(), ErrInvalidDomainName.Error())
			} else {
				urequire.NoError(t, err)
				urequire.Equal(t, c.expected.Avatar, retrievedMetadata.Avatar)
				urequire.Equal(t, c.expected.Description, retrievedMetadata.Description)
				urequire.Equal(t, c.expected.ContactInfo, retrievedMetadata.ContactInfo)
			}
		})
	}
}

func TestTransferDomain(t *testing.T) {
	registry := NewDomainRegistry("GNO Name Service", "GNS")

	cases := []struct {
		name        string
		owner       std.Address
		newOwner    std.Address
		caller      std.Address
		domainName  string
		expectError bool
	}{
		{
			name:        "Successful Transfer",
			owner:       addr1,
			newOwner:    addr2,
			caller:      addr1,
			domainName:  "transfer.gno",
			expectError: false,
		},
		{
			name:        "Non-Owner Attempts Transfer",
			owner:       addr1,
			newOwner:    addr2,
			caller:      addr2,
			domainName:  "transfer.gno",
			expectError: true,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			std.TestSetRealm(std.NewUserRealm(c.owner))
			std.TestSetOrigCaller(c.owner)

			metadata := Metadata{
				Avatar:           "avatar_url",
				RegistrationTime: time.Now(),
				ExpirationTime:   time.Now().Add(365 * 24 * time.Hour),
				Description:      "A transferable domain",
				ContactInfo:      "gno_name_service@gno.land",
			}

			registry.RegisterDomain(c.owner, c.domainName, metadata)

			std.TestSetRealm(std.NewUserRealm(c.caller))
			std.TestSetOrigCaller(c.caller)

			err := registry.TransferFrom(c.owner, c.newOwner, c.domainName)
			if c.expectError {
				urequire.Error(t, err)
				urequire.Equal(t, err.Error(), grc721.ErrTransferFromIncorrectOwner.Error())
			} else {
				urequire.NoError(t, err)

				retrievedOwner, err := registry.OwnerOf(c.domainName)
				urequire.NoError(t, err)
				urequire.Equal(t, c.newOwner, retrievedOwner)
			}
		})
	}
}
