package resolver

import (
	"errors"
)

var (
	ErrNotFound          = errors.New("not found")
	ErrBadCall           = errors.New("bad call")
	ErrInvalidDomainName = errors.New("invalid domain name to register")
)
