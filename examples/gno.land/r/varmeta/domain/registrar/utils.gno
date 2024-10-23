/*
This check module contains function to do the checking stuffs
*/
package registrar

import (
	"regexp"
	"time"
)

var (
	defaultCommitHashTime  = time.Second * 30
	defaultCommitPriceTime = time.Second * 30
	defaultExpireTime      = time.Hour // 30 days
	reName                 = regexp.MustCompile(`^[a-zA-Z0-9]{1,124}\.gno$`)
)

// check for registering process
func isValidDomain(d string) bool {
	return reName.MatchString(d)
}

func GetExpirationDate(dName string) time.Time {
	return rootRegistry.GetExpirationDate(dName)
}

// for now, this function only let admin set
func SetExpirationDate(dName string, expDate time.Time) bool {
	assertIsAdmin()
	return rootRegistry.SetExpirationDate(dName, expDate)
}

func SetCommitPhaseTime(duration int) {
	defaultCommitHashTime = time.Duration(duration) * time.Second
}

func SetCommitPriceTime(duration int) {
	defaultCommitPriceTime = time.Duration(duration) * time.Second
}
