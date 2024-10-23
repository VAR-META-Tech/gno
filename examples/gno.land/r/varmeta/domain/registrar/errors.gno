package registrar

import (
	"errors"
)

var (
	ErrUnknown           = errors.New("unknow errors")
	ErrOK                = errors.New("ok")
	ErrBadCall           = errors.New("bad call")
	ErrInvalidDomainName = errors.New("ErrInvalidDomainName")
	ErrAlreadyRegistered = errors.New("this domain is registered")
	ErrCrossRealms       = errors.New("cross realms function error")
	ErrNotFound          = errors.New("domain not found")
)
