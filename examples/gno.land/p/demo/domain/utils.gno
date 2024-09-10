package domain

type MetadataField int

const (
	FieldAvatar MetadataField = iota
	FieldRegistrationTime
	FieldRenewalFee
	FieldExpirationTime
	FieldAttributes
	FieldDescription
	FieldContactInfo
)
