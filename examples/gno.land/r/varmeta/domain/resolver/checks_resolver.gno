/*
This check module contains function to do the checking stuffs
*/
package resolver

import (
	"regexp"
	"time"

	"gno.land/r/varmeta/demo/v7/domain/registrar"
)

// const (
// 	admin std.Address = "g162jgpk4740r6a7g53cgz9ahxqtyuekgqchw6w9" // -> @thinhnx
// )

var reName = regexp.MustCompile(`^[a-zA-Z0-9]{1,124}\.gno$`)

// check for registering process
func isValidDomain(d string) bool {
	return reName.MatchString(d)
}

func isExpired(dName string) bool {
	expDate := registrar.GetExpirationDate(dName)
	return expDate.Before(time.Now())
}
