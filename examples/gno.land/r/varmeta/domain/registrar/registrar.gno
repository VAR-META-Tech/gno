/*
This package contains functions that will actually execute the request from user
Features: Domain Registration, Domain Renewal, Domain Transfer, Domain Deletion...
*/
// changelogs 1: move fee mgnt to registrar module, in oder to manage the coins sent from user to realm.
// changelogs 2: v2 - added sealed bidding logic - with default time xxx mins for each session

// currently we dont using too much panic because we dont have defer functions to revert the state of storage
package registrar

import (
	"std"
	"time"

	"gno.land/p/varmeta/demo/v7/domain"
)

// XXX: consider using panic instead of return string or errors
func Register(domainName string, mode string) string {
	requestInfo := RequestInfo{
		WantedDomain: domainName,
		Caller:       std.PrevRealm().Addr(),
		Mode:         mode,
	}

	regResult := executeRegister(requestInfo)

	// calling panic to stop paying fee
	if !regResult.Success {
		panic(regResult.ResultDetails.Error())
	}
	// pay fee with panic inside
	feeProcess(requestInfo)
	return "Register Done"
}

func executeRegister(req RequestInfo) ExecuteResult {
	// check if domain name is regex valid
	var execRes ExecuteResult
	if !isValidDomain(req.WantedDomain) {
		execRes.Success = false
		execRes.ResultDetails = ErrInvalidDomainName
		return execRes
	}

	// check if dName is registered
	if AlreadyRegistered(req.WantedDomain) {
		execRes.Success = false
		execRes.ResultDetails = ErrAlreadyRegistered
		return execRes
	}

	// execute register domain - mint the nft
	// changelogs v2: we are using sealed bidding now

	caller := req.Caller
	ttl := defaultExpireTime
	metadata := metadataWrapper(caller, req.WantedDomain, ttl)
	// create a new registry instance to save metadata and mint the NFT
	errRegister := rootRegistry.RegisterDomain(caller, req.WantedDomain, metadata, ttl)
	if errRegister != nil {
		execRes.Success = false
		execRes.ResultDetails = ErrCrossRealms
		return execRes
	}
	// now save caller to corressponding tree to manage
	domainStorage.Set(req.WantedDomain, caller)

	execRes.Success = true
	return execRes
}

func feeProcess(req RequestInfo) {
	if req.Mode == "token" {
		nativeProcess()
	} else {
		nativeProcess()
	}
}

func AlreadyRegistered(domainName string) bool {
	// if can get owner -> existed
	addr, err := rootRegistry.OwnerOf(domainName)
	if err == nil && addr != "" {
		return true
	}
	return false
}

func GetOwner(domainName string) std.Address {
	vl, existed := domainStorage.Get(domainName)
	if !existed {
		return ""
	}
	return vl.(std.Address)
}

func Search(domainName string) (remapMetadata, string) {
	validMetadata := remapMetadata{}
	md, err := getMetadata(domainName)
	if err != nil {
		// return validMetadata, err.Error()
		panic(err)
	}
	validMetadata.RegistrationTime = md.RegistrationTime.Format(time.RFC3339)
	validMetadata.ExpirationTime = md.ExpirationTime.Format(time.RFC3339)
	// jsonData, _ := validMetadata.MarshalJSON()
	return validMetadata, "Search Success"
}

func getMetadata(wantedDomain string) (domain.Metadata, error) {
	// confirm the method? -> get all the fields if the fields slice is empty
	metadata, err := rootRegistry.GetDomainFields(wantedDomain, []domain.MetadataField{})
	if err != nil {
		return metadata, err
	}
	return metadata, nil
}

// Transfer
func TransferDomain(from, to, domainName string) string {
	requestInfo := RequestInfo{
		WantedDomain: domainName,
		Caller:       std.PrevRealm().Addr(),
	}
	if err := excuteTransfer(requestInfo); err != "" {
		panic(err)
	}
	return "Transfer Done"
}

func excuteTransfer(req RequestInfo) string {
	if !AlreadyRegistered(req.WantedDomain) {
		return ErrAlreadyRegistered.Error()
	}
	rootRegistry.TransferFrom(req.TransInfo.From, req.TransInfo.To, req.WantedDomain)
	return ""
}

func GetDomainName(addr string) []string {
	domainList := []string{}
	// search from local storage
	domainStorage.Iterate("", "", func(key string, value interface{}) bool {
		caller := value.(std.Address)
		// not checking isExpired
		if caller.String() == addr {
			domainList = append(domainList, key)
		}
		return false
	})
	return domainList
}
