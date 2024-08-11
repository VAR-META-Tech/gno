package domain

import (
	"errors"
)

var (
	ErrUnauthorized         = errors.New("caller is not domain owner")
	ErrInvalidDomainName    = errors.New("invalid domain name")
	ErrInvalidMetadataField = errors.New("invalid metadata field")
	ErrInsufficientFunds    = errors.New("insufficient funds for renewal")
)
