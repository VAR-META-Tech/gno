package registrar

import (
	"bytes"
	"std"
	"time"

	"gno.land/p/demo/ufmt"

	"gno.land/p/varmeta/demo/v7/domain"
)

// Metadata wrapper
// func NewMetadata(avatar, description, contactInfo, renewalFee string, registrationTime, expirationTime time.Time, attributes []Trait)
func metadataWrapper(owner std.Address, name string, ttl time.Duration) domain.Metadata {
	createdAt := time.Now()
	expTime := createdAt.Add(ttl)
	return domain.NewMetadata("", name, "", "", createdAt, expTime, []domain.Trait{})
}

type remapMetadata struct {
	Avatar           string         // avatar - URL or identifier for an avatar image
	RegistrationTime string         // regtime - The time when the domain was registered
	ExpirationTime   string         // exptime - The time when the domain will be expire
	Attributes       []domain.Trait // atts - Additional attributes of the domain
	Description      string         // des - A description of the domain
	ContactInfo      string         // contacts - Contact information for the domain owner
	RenewalFee       string         // renewalfee - The fee required to renew the domain, represented as a string
}

// currently not support for arrays
func (m remapMetadata) MarshalJSON() ([]byte, error) {
	json := new(bytes.Buffer)
	if m.Attributes == nil {
		json.WriteString(ufmt.Sprintf(`{"avatar": %s, "regtime": %s, "exptime": %s, "atts": %s, "des": %s, "contacts": %s, "renewalfee": %s}`, m.Avatar, m.RegistrationTime, m.ExpirationTime, "empty", m.Description, m.ContactInfo, m.RenewalFee))
		return json.Bytes(), nil
	}
	json.WriteString(ufmt.Sprintf(`{"avatar": %s, "regtime": %s, "exptime": %s, "atts": %s, "des": %s, "contacts": %s, "renewalfee": %s}`, m.Avatar, m.RegistrationTime, m.ExpirationTime, m.Attributes[0], m.Description, m.ContactInfo, m.RenewalFee))
	return json.Bytes(), nil
}
