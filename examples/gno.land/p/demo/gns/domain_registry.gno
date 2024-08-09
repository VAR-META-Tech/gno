package gns

import (
	"std"
	"time"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/grc/grc721"
	"gno.land/p/demo/ownable"
)

// domainRegistry represents a registry for domain names with metadata
type domainRegistry struct {
	domains  grc721.IGRC721 // Interface for basic NFT functionality
	metadata *avl.Tree      // AVL tree for storing domain metadata
}

// DomainRegistry defines the methods for managing domain names and metadata
type DomainRegistry interface {
	BalanceOf(owner std.Address) (uint64, error)
	OwnerOf(domainName string) (std.Address, error)
	SafeTransferFrom(from, to std.Address, domainName string) error
	TransferFrom(from, to std.Address, domainName string) error
	Approve(approved std.Address, domainName string) error
	SetApprovalForAll(operator std.Address, approved bool) error
	GetApproved(domainName string) (std.Address, error)
	IsApprovedForAll(owner, operator std.Address) bool
	Mint(to std.Address, domainName string) error

	RegisterDomain(owner std.Address, domainName string, metadata Metadata) error
	SetDomainData(domainName string, metadata Metadata) error
	GetDomainData(domainName string, field MetadataField) (Metadata, error)
	GetDomainFields(domainName string, fields []MetadataField) (Metadata, error)
	RenewDomain(domainName string, additionalDuration time.Duration) error
}

// NewDomainRegistry creates a new domain registry with metadata extensions
func NewDomainRegistry(name, symbol string) *domainRegistry {
	registry := grc721.NewBasicNFT(name, symbol)

	return &domainRegistry{
		domains:  registry,
		metadata: avl.NewTree(),
	}
}

func (d *domainRegistry) RegisterDomain(owner std.Address, domainName string, metadata Metadata) error {
	err := d.domains.Mint(owner, grc721.TokenID(domainName))
	if err != nil {
		return err
	}

	d.metadata.Set(domainName, metadata)

	return nil
}

// RenewDomain extends the expiration time of a domain name
func (d *domainRegistry) RenewDomain(domainName string, additionalDuration time.Duration) error {
	data, found := d.metadata.Get(domainName)
	if !found {
		return ErrInvalidDomainName
	}

	metadata := data.(Metadata)

	owner, err := d.domains.OwnerOf(grc721.TokenID(domainName))
	if err != nil {
		return err
	}

	caller := std.PrevRealm().Addr()
	if caller != owner {
		return ErrUnauthorized
	}

	// Todo : apply deduction renewal fee here

	metadata.ExpirationTime.Add(additionalDuration)
	d.metadata.Set(domainName, metadata)

	return nil
}

// SetDomainData sets the metadata for a given domain name
func (d *domainRegistry) SetDomainData(domainName string, metadata Metadata) error {
	owner, err := d.domains.OwnerOf(grc721.TokenID(domainName))
	if err != nil {
		return err
	}

	caller := std.PrevRealm().Addr()
	if caller != owner {
		return ErrUnauthorized
	}

	d.metadata.Set(domainName, metadata)
	return nil
}

// GetDomainFields retrieves multiple fields of metadata for a given domain
func (d *domainRegistry) GetDomainFields(domainName string, fields []MetadataField) (Metadata, error) {
	data, found := d.metadata.Get(domainName)
	if !found {
		return Metadata{}, ErrInvalidDomainName
	}

	metadata := data.(Metadata)

	if len(fields) == 0 {
		return metadata, nil
	}

	var result Metadata
	for _, field := range fields {
		switch field {
		case FieldAvatar:
			result.Avatar = metadata.Avatar
		case FieldRegistrationTime:
			result.RegistrationTime = metadata.RegistrationTime
		case FieldExpirationTime:
			result.ExpirationTime = metadata.ExpirationTime
		case FieldRenewalFee:
			result.RenewalFee = metadata.RenewalFee
		case FieldAttributes:
			result.Attributes = metadata.Attributes
		case FieldDescription:
			result.Description = metadata.Description
		case FieldContactInfo:
			result.ContactInfo = metadata.ContactInfo
		default:
			return Metadata{}, ErrInvalidMetadataField
		}
	}

	return result, nil
}

// GetDomainData retrieves metadata for a given domain
func (d *domainRegistry) GetDomainData(domainName string, field MetadataField) (Metadata, error) {
	data, found := d.metadata.Get(domainName)
	if !found {
		return Metadata{}, ErrInvalidDomainName
	}

	metadata := data.(Metadata)

	switch field {
	case FieldAvatar:
		return Metadata{
			Avatar: metadata.Avatar,
		}, nil
	case FieldRegistrationTime:
		return Metadata{
			RegistrationTime: metadata.RegistrationTime,
		}, nil
	case FieldExpirationTime:
		return Metadata{
			ExpirationTime: metadata.ExpirationTime,
		}, nil
	case FieldRenewalFee:
		return Metadata{
			RenewalFee: metadata.RenewalFee,
		}, nil
	case FieldAttributes:
		return Metadata{
			Attributes: metadata.Attributes,
		}, nil
	case FieldDescription:
		return Metadata{
			Description: metadata.Description,
		}, nil
	case FieldContactInfo:
		return Metadata{
			ContactInfo: metadata.ContactInfo,
		}, nil
	default:
		return Metadata{}, ErrInvalidMetadataField
	}
}

func (d *domainRegistry) BalanceOf(owner std.Address) (uint64, error) {
	return d.domains.BalanceOf(owner)
}

func (d *domainRegistry) OwnerOf(domainName string) (std.Address, error) {
	return d.domains.OwnerOf(grc721.TokenID(domainName))
}

func (d *domainRegistry) SafeTransferFrom(from, to std.Address, domainName string) error {
	return d.domains.SafeTransferFrom(from, to, grc721.TokenID(domainName))
}

func (d *domainRegistry) TransferFrom(from, to std.Address, domainName string) error {
	return d.domains.TransferFrom(from, to, grc721.TokenID(domainName))
}

func (d *domainRegistry) Approve(approved std.Address, domainName string) error {
	return d.domains.Approve(approved, grc721.TokenID(domainName))
}

func (d *domainRegistry) SetApprovalForAll(operator std.Address, approved bool) error {
	return d.domains.SetApprovalForAll(operator, approved)
}

func (d *domainRegistry) GetApproved(domainName string) (std.Address, error) {
	return d.domains.GetApproved(grc721.TokenID(domainName))
}

func (d *domainRegistry) IsApprovedForAll(owner, operator std.Address) bool {
	return d.domains.IsApprovedForAll(owner, operator)
}

func (d *domainRegistry) Mint(to std.Address, domainName string) error {
	return d.domains.Mint(to, grc721.TokenID(domainName))
}
