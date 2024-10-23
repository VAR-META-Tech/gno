package registrar

// import (
// 	"std"
// 	"strconv"
// 	"time"

// 	"gno.land/p/demo/ufmt"
// 	// "gno.land/p/demo/mux"
// 	"gno.land/p/demo/avl"
// )

// var (
// 	bidStorage *avl.Tree // bidRecord <- []bidRec
// 	winnerRec  *avl.Tree // dName <- bidRec
// 	joinedBid  *avl.Tree // address <- []string DomainName
// )

// func recordJoinedBid(domainName string) {
// 	caller := std.GetOrigCaller()
// 	dList := []string{}
// 	data, existed := joinedBid.Get(caller.String())
// 	if !existed {
// 		dList = []string{domainName}
// 		joinedBid.Set(caller.String(), dList)
// 		return
// 	}
// 	dList = data.([]string)
// 	dList = append(dList, domainName)
// 	joinedBid.Set(caller.String(), dList)
// 	return
// }

// // GetJoinedBid returns the status of an user's joined bid session information
// func GetJoinedBid(caller string) []bidStatus {
// 	data, existed := joinedBid.Get(caller)
// 	if !existed {
// 		return []bidStatus{}
// 	}
// 	list := data.([]string)
// 	listStatus := []bidStatus{}
// 	for _, dName := range list {
// 		stt := GetCurrentStatus(dName, caller)

// 		// get the time stamp in [0] element and assign it to status
// 		data, _ := bidStorage.Get(dName)
// 		bidRec := data.([]bidRecord)[0]

// 		singleStt := bidStatus{
// 			DomainName:    dName,
// 			Status:        stt,
// 			EndCommitTime: bidRec.EndCommitTime,
// 			EndPriceTime:  bidRec.EndPriceTime,
// 		}
// 		listStatus = append(listStatus, singleStt)
// 	}
// 	return listStatus
// }

// // GetCurrentStatus returns the status of the bidding session about a domain name. This func requires caller to determine in case commited or not (hash or price)
// func GetCurrentStatus(domainName string, caller string) string {
// 	// if there is record in joinedBid -> user joined
// 	// check for tine.Now() and startTime
// 	now := time.Now().UnixMilli()
// 	owner := GetOwner(domainName)
// 	if owner != "" {
// 		return "owned by " + owner.String()
// 	}
// 	// find the record
// 	data, existed := bidStorage.Get(domainName)
// 	if !existed {
// 		// no record in bidRec yet -> not commited -> check if user started auction or not - if yes: new auction
// 		if dataJoined, existedInRegister := joinedBid.Get(caller); existedInRegister {
// 			dNameList := dataJoined.([]string)
// 			for _, dName := range dNameList {
// 				if dName == domainName {
// 					return "waiting for hash"
// 				}
// 				return "domain name is free"
// 			}
// 		}
// 		return "domain name is free"
// 	}

// 	// commited yet
// 	recList := data.([]bidRecord)
// 	rec := recList[0]
// 	endCommitTimeUnix := rec.EndCommitTime
// 	endPriceTimeUnix := rec.EndPriceTime
// 	if now < endCommitTimeUnix {
// 		if rec.HashString != "" {
// 			return "commited hash"
// 		} else {
// 			return "hash"
// 		}
// 	}

// 	ufmt.Println("now: ", time.UnixMilli(now))
// 	ufmt.Println("endPriceTime: ", time.UnixMilli(endPriceTimeUnix))
// 	if now < endPriceTimeUnix && now > endCommitTimeUnix {
// 		// check if commited price
// 		data, _ := bidStorage.Get(domainName)
// 		bidRecList := data.([]bidRecord)
// 		thisRec := bidRecord{}
// 		for _, bidRec := range bidRecList {
// 			if bidRec.Bidder.String() == caller {
// 				thisRec = bidRec
// 			}
// 		}
// 		if thisRec.IsCommittedPrice {
// 			return "committed price"
// 		}
// 		return "price"
// 	}
// 	if now > rec.EndPriceTime {
// 		// check if dName is claiming by winner - check if winner existed
// 		if data, existed := winnerRec.Get(domainName); existed {
// 			winner := data.(bidRecord)
// 			return winner.Bidder.String() + " is claiming domain name: " + domainName
// 		}
// 		return "closed"
// 	}
// 	return "undefined"
// }

// // Render() renders welcome message :D
// func Render(path string) string {
// 	return "welcome to varmeta domain name service"
// }

// // CommitHash consumes off-chain calculated hash string and the domain name that user want
// func CommitHash(domainName, hashString string) string {
// 	caller := std.GetOrigCaller()

// 	// use now as int64 representation of time.Now()
// 	now := time.Now().UnixMilli()

// 	// update the bid record
// 	data, existed := bidStorage.Get(domainName)

// 	// if not existed -> create new record
// 	if !existed {
// 		// for further getStatus
// 		recordJoinedBid(domainName)

// 		var bidRec bidRecord
// 		endCommitTime := now + defaultCommitHashTime.Milliseconds()
// 		endPriceTime := endCommitTime + defaultCommitPriceTime.Milliseconds()
// 		ufmt.Println("[HASH]: request at: ", time.UnixMilli(now))
// 		ufmt.Println("[HASH]: endCommitTime: ", time.UnixMilli(endCommitTime))
// 		ufmt.Println("[HASH]: endPriceTime: ", time.UnixMilli(endPriceTime))
// 		bidRec = bidRecord{
// 			DomainName:    domainName,
// 			Bidder:        caller,
// 			HashString:    hashString,
// 			StartTime:     now,
// 			EndCommitTime: endCommitTime,
// 			EndPriceTime:  endPriceTime,
// 		}
// 		bidRecList := []bidRecord{bidRec}
// 		bidStorage.Set(domainName, bidRecList)

// 		// charge fee
// 		chargeFee(fee.BidJoinFee, caller)
// 		return "new session"
// 	}
// 	// if existed
// 	bidRecList := data.([]bidRecord)
// 	startTime := bidRecList[0].StartTime
// 	oldEndCommitTimeUnix := bidRecList[0].EndCommitTime
// 	oldEndPriceTimeUnix := bidRecList[0].EndPriceTime
// 	if now > oldEndCommitTimeUnix {
// 		// now := time.Now().UnixMilli()
// 		// ufmt.Println("[HASH]: now: ", time.UnixMilli(now))
// 		panic("[HASH]: can not commit hash anymore")
// 	}
// 	for _, bR := range bidRecList {
// 		if bR.Bidder == caller {
// 			panic("[HASH]: you already commited hash")
// 		}
// 	}

// 	bidRec := bidRecord{
// 		DomainName:    domainName,
// 		HashString:    hashString,
// 		Bidder:        caller,
// 		StartTime:     startTime,
// 		EndCommitTime: oldEndCommitTimeUnix,
// 		EndPriceTime:  oldEndPriceTimeUnix,
// 	}
// 	bidRecList = append(bidRecList, bidRec)
// 	// Save record
// 	bidStorage.Set(domainName, bidRecList)
// 	// charge commit hash fee
// 	chargeFee(fee.BidJoinFee, caller)
// 	return "existed"
// }

// // for now we dont use panic because this will cause the permanent time.Now() stuck. IDK why // XXX fix me
// // CommitPrice consumes price and secret string that user used in calculating hash string from off-chain. This will re-calculate the hashstring and compare with the one commited before
// func CommitPrice(price int64, secret string, domainName string) string {
// 	// compute the hash string, compare to saved hash string in record
// 	// use int64 representation of time.Now()
// 	now := time.Now().UnixMilli()
// 	ufmt.Println("[PRICE]: request at: ", time.UnixMilli(now))
// 	joinedString := secret + strconv.Itoa(int(price))
// 	computedHashString := Get256String(joinedString)
// 	caller := std.GetOrigCaller()
// 	data, existed := bidStorage.Get(domainName)
// 	if !existed {
// 		panic("[PRICE]: domain name is invalid")
// 	}
// 	bidRecList := data.([]bidRecord)
// 	winnerRec.Set(domainName, bidRecList[len(bidRecList)-1])
// 	ufmt.Println("[PRICE] current winner set to: ", bidRecList[len(bidRecList)-1].Bidder.String())

// 	ufmt.Println("[PRICE]: request at: ", time.UnixMilli(now))
// 	ufmt.Println("[PRICE]: endPriceTime: ", time.UnixMilli(bidRecList[0].EndPriceTime))
// 	// case commit after end - consider panic or not
// 	if now > bidRecList[0].EndPriceTime {
// 		ufmt.Println("[PRICE]: commit price phase is ended")
// 		return "ended"
// 	}
// 	// case commit when price phase not started
// 	if now <= bidRecList[0].EndCommitTime {
// 		ufmt.Println("[PRICE]: commit price phase is not started yet")
// 		return "not started yet"
// 	}

// 	// search for the corresponding hash
// 	for index, bidRec := range bidRecList {
// 		// panic because wrong price or wrong secret string
// 		if bidRec.Bidder == caller && bidRec.HashString != computedHashString {
// 			panic("[PRICE]: invalid hash string")
// 		}
// 		// found it, update the winner price
// 		if bidRec.Bidder == caller && bidRec.HashString == computedHashString {
// 			data, _ := winnerRec.Get(domainName)
// 			currentWinnerRec := data.(bidRecord)
// 			if price > currentWinnerRec.Price && now < currentWinnerRec.EndPriceTime {
// 				ufmt.Println("[PRICE]: found new winner, setting up")
// 				currentWinnerRec.Price = price
// 				currentWinnerRec.Bidder = bidRec.Bidder
// 				currentWinnerRec.HashString = bidRec.HashString
// 				currentWinnerRec.StartTime = bidRec.StartTime
// 				currentWinnerRec.EndCommitTime = bidRec.EndCommitTime
// 				currentWinnerRec.EndPriceTime = bidRec.EndPriceTime
// 				winnerRec.Set(domainName, currentWinnerRec)
// 				ufmt.Println("[PRICE] current winner set to: ", currentWinnerRec.Bidder)
// 				bidRec.IsCommittedPrice = true
// 				// set new bidRecord into bidRecList and save into storage
// 				bidRecList[index] = bidRec
// 				bidStorage.Set(domainName, bidRecList)
// 				return "claim"
// 			}
// 		}
// 	}
// 	// if not match above case, then panic
// 	panic("commit price failed")
// }

// // GetCurrentWinner shows the current highest price user
// func GetCurrentWinner(domainName string) bidRecord {
// 	data, existed := winnerRec.Get(domainName)
// 	if !existed {
// 		panic("no winner yet")
// 	}
// 	return data.(bidRecord)
// }

// // find the highest bid in session - incase everyone commited price
// // in old flow, we need to find the winner by retrievaling the bidStorage
// func findTheWinner(domainName string) bidRecord {
// 	var winnerBid bidRecord
// 	data, existed := bidStorage.Get(domainName)
// 	if !existed {
// 		panic("invalid domain name")
// 	}
// 	bidRecList := data.([]bidRecord)
// 	winnerBid = bidRecList[0]
// 	for _, bidRec := range bidRecList {
// 		if bidRec.Price > winnerBid.Price {
// 			winnerBid = bidRec
// 		}
// 	}
// 	return winnerBid
// }

// // register the domain for winner
// func registerForWinner(domainName string, winnerRec bidRecord) bool {
// 	winnerAddr := winnerRec.Bidder
// 	requestInfo := RequestInfo{
// 		WantedDomain: domainName,
// 		Caller:       winnerAddr,
// 		Mode:         "native",
// 	}
// 	result := executeRegister(requestInfo)
// 	if !result.Success {
// 		panic(result.ResultDetails.Error())
// 	}
// 	// register done. Now charge the fee
// 	feeProcess(requestInfo)
// 	return false
// }

// // everyone can call EndBid()
// // this EndBid checks endTime -> end the auction
// func EndBid(domainName string) error {
// 	now := time.Now().UnixMilli()
// 	data, existed := bidStorage.Get(domainName)
// 	if !existed {
// 		return ufmt.Errorf("endbid: invalid domain name")
// 	}
// 	bidRecList := data.([]bidRecord)
// 	firstBidRec := bidRecList[0]
// 	if now < firstBidRec.EndPriceTime {
// 		return ufmt.Errorf("endbid: this session can not end before the end time")
// 	}
// 	// change all state
// 	// for _, bidRec := range bidRecList {
// 	// 	bidRec.IsOpen = false
// 	// }
// 	ok := bidStorage.Set(domainName, bidRecList)
// 	if !ok {
// 		return ufmt.Errorf("endbid: can not change bid record state")
// 	}
// 	// need more conditions for findTheWinner()
// 	findTheWinner(domainName)
// 	return nil
// }

// // get all the price list that joined the bid for displaying in dapp
// func GetRecords(dName string) []bidRecord {
// 	data, existed := bidStorage.Get(dName)
// 	if !existed {
// 		panic("should not")
// 	}
// 	return data.([]bidRecord)
// }

// // chargeFee will charge amount - send from this contract to admin
// func chargeFee(amount int64, from std.Address) {
// 	bankerContract := std.CurrentRealm().Addr()
// 	ugnotCoin := std.NewCoin("ugnot", amount)
// 	coinsToTransfer := std.NewCoins(ugnotCoin)
// 	coins := checkCoin(from)
// 	ufmt.Println("check balances: ", coins)
// 	// ufmt.Println("send from contract ", bankerContract.String(), " to admin ", admin.String(), " amount: ", ugnotCoin)
// 	bankerUser.SendCoins(bankerContract, admin, coinsToTransfer)
// }

// // pay fee and claim the domain name if you are winner
// func Claim(domainName string) bool {
// 	data, existed := winnerRec.Get(domainName)
// 	if !existed {
// 		panic("claim: invalid domain name")
// 	}
// 	caller := std.GetOrigCaller()
// 	rec := data.(bidRecord)
// 	if caller != rec.Bidder {
// 		panic("only winner can claim")
// 	}
// 	requestInfo := RequestInfo{
// 		WantedDomain: domainName,
// 		Caller:       rec.Bidder,
// 		Mode:         "native",
// 	}
// 	result := executeRegister(requestInfo)
// 	if !result.Success {
// 		panic(result.ResultDetails.Error())
// 	}
// 	// register done. Now charge the fee
// 	chargeFee(rec.Price, caller)
// 	feeProcess(requestInfo)
// 	return true
// }

// // expose winner price - amount of fee that user need to pay in Claim phase
// func GetWinnerPrice(dName string) int64 {
// 	rec := GetCurrentWinner(dName)
// 	return rec.Price
// }