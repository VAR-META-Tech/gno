/*
The goal of the Resolver contract is keep track of the address for each ICNS name in a stateful manner.
It serves the purpose of "resolving" the ICNS Name
to the correct address (e.g "alice.gno" -> g1xxx).
*/
// changelogs: move Register feature into this resolver package
// changelogs2: Removed local storage of resolver as cache, and every querires we query to registrar to get the result

package resolver

import (
	"std"

	"gno.land/r/varmeta/demo/v7/domain/registrar"
)

type Record struct {
	Owner    std.Address
	IsValid  bool
	Memo     string // no more need this
	Priority int
}

// retrieve the record list to get the onchain address
func Resolve(domainName string) *Record {
	if !isValidDomain(domainName) {
		panic("bad domain name")
	}
	record := &Record{}

	owner := getOwnerFromDomainStorage(domainName)
	if owner == "" {
		record.Memo = "not found"
		record.IsValid = false
		return record
	}

	if !isExpired(domainName) {
		record.IsValid = true
		record.Owner = owner
	} else {
		record.IsValid = false
	}
	return record
}

func GetDomainName(addr string) []string {
	return registrar.GetDomainName(addr)
}

/*
If query in local storage not found
Query to DomainStorage by domainName -> get the registry -> use that registry to get the Owner()
and check the validation time?
*/

func existedInDomainStorage(domainName string) bool {
	return registrar.AlreadyRegistered(domainName)
}

func getOwnerFromDomainStorage(domainName string) std.Address {
	return registrar.GetOwner(domainName)
}
