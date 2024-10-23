/*
	this realm is implementaion of sealed bidding package, which object is domainName
	this realm charges fee itself and not relate to the logic of sealed bidding
*/

package registrar

import (
	"std"
	"time"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
	sbid "gno.land/p/varmeta/demo/v7/sbid"
)

var root *avl.Tree // domainName <- *sbid.Bid{BidInfo}

func init() {
	root = avl.NewTree()
}

func newBid(domainName string) *sbid.Bid {
	// initial timestamp for bid session
	now := time.Now()
	endHashTime := now.Add(defaultCommitHashTime)
	endPriceTime := now.Add(defaultCommitHashTime + defaultCommitPriceTime)
	ufmt.Println("new bid on: ", now, " endHash: ", endHashTime)
	bid := &sbid.Bid{
		Infos:        avl.NewTree(),
		StartTime:    now.UnixMilli(),
		EndHashTime:  endHashTime.UnixMilli(),
		EndPriceTime: endPriceTime.UnixMilli(),
	}
	ufmt.Println("value now saved: ", now.UnixMilli())
	root.Set(domainName, bid)
	return bid
}

// getBid returns the existed pointer to bid session in root. if there isnt, it will create new bid session
func getBid(domainName string) *sbid.Bid {
	var bid *sbid.Bid
	data, _ := root.Get(domainName)
	bid = data.(*sbid.Bid)
	return bid
}

func isBidExisted(dName string) bool {
	return root.Has(dName)
}

func CommitHash(domainName string, hashString string) string {
	now := time.Now()
	ufmt.Println("commit hash at: ", now)
	var bid *sbid.Bid
	if isBidExisted(domainName) {
		bid = getBid(domainName)
	} else {
		bid = newBid(domainName)
	}
	caller := std.GetOrigCaller().String()
	// commit hash will also update info tree of the bid session
	result := bid.CommitHash(domainName, hashString, caller)
	if result == "committed hash" {
		chargeFee(fee.BidJoinFee, std.Address(caller))
	}
	return result
}

func GetTimeNow() int64 {
	return time.Now().UnixMilli()
}

func CommitPrice(domainName string, price int64, secret string) string {
	now := time.Now()
	ufmt.Println("commit price at: ", now)
	var bid *sbid.Bid
	if isBidExisted(domainName) {
		bid = getBid(domainName)
	} else {
		// follow the logic: if you commit price without committed hash
		return "you did not committed the hash"
	}
	caller := std.GetOrigCaller().String()
	return bid.CommitPrice(domainName, price, secret, caller)
}

func GetJoinedBid(caller string) []sbid.BidStatus {
	return findStatusInRoot(caller)
}

func findStatusInRoot(caller string) []sbid.BidStatus {
	listStt := []sbid.BidStatus{}
	root.Iterate("", "", func(key string, value interface{}) bool {
		bid := value.(*sbid.Bid)
		if bid.Infos.Has(caller) {
			// owner := GetOwner(key)
			// if owner != "" {
			// 	ownedBy := ufmt.Sprintf("owned by %s", owner.String())
			// 	newStt := sbid.BidStatus{
			// 		BidObject: key,
			// 		Status:    ownedBy,
			// 	}
			// 	listStt = append(listStt, newStt)
			// 	// returns false to avoid duplicate status
			// 	return false
			// }
			stt := bid.GetStatus(key, caller)
			listStt = append(listStt, stt)
		}
		return false
	})
	return listStt
}

func GetCurrentStatus(dName string, caller string) string {
	owner := GetOwner(dName)
	if owner != "" {
		return "owned by " + owner.String()
	}
	// TODO: this getBid func will create new bid session if there is no bid existed
	// -> fix it please -> separate getBid logic (DONE)
	var bid *sbid.Bid
	if !isBidExisted(dName) {
		return "domain name is free"
	} else {
		bid = getBid(dName)
	}
	status := bid.GetStatus(dName, caller)
	// checking this for dapps purpose
	if status.Status == "free" {
		// this caller is not joining bidding session
		return "domain name is free"
	}
	// Auction closed with winner
	now := time.Now().UnixMilli()
	if bid.EndPriceTime <= now && owner != "" {
		return "close"
	}
	// both undefined
	return status.Status
}

func GetCurrentWinner(dName string) string {
	var bid *sbid.Bid
	if isBidExisted(dName) {
		bid = getBid(dName)
	} else {
		return "no session for this domain yet"
	}
	winner := bid.GetCurrentWinnerInfo()
	if !winner.IsWinner {
		return "no winner yet"
	}
	return winner.Bidder
}

func now() int64 {
	return time.Now().UnixMilli()
}

func Claim(dName string) string {
	if !root.Has(dName) {
		panic("invalid domain name")
	}
	var bid *sbid.Bid
	if isBidExisted(dName) {
		bid = getBid(dName)
	} else {
		bid = newBid(dName)
	}
	caller := std.GetOrigCaller()
	winner := bid.GetCurrentWinnerInfo()
	if caller.String() != winner.Bidder {
		panic("only winner can claim")
	}
	requestInfo := RequestInfo{
		WantedDomain: dName,
		Caller:       caller,
		Mode:         "native",
	}
	result := executeRegister(requestInfo)
	if !result.Success {
		panic("bad register")
	}
	chargeFee(winner.Price, caller)
	feeProcess(requestInfo)
	return "claimed"
}

// // expose winner price - amount of fee that user need to pay in Claim phase
func GetWinnerPrice(dName string) int64 {
	var bid *sbid.Bid
	if isBidExisted(dName) {
		bid = getBid(dName)
	} else {
		bid = newBid(dName)
	}

	baseRegisterFee := GetRegisterFee(dName)
	winner := bid.GetCurrentWinnerInfo()
	return winner.Price + baseRegisterFee
}

func chargeFee(amount int64, from std.Address) string {
	bankerContract := std.CurrentRealm().Addr()
	ugnotCoin := std.NewCoin("ugnot", amount)
	coinsToTransfer := std.NewCoins(ugnotCoin)
	// coins := checkCoin(from)
	// ufmt.Println("send from contract ", bankerContract.String(), " to admin ", admin.String(), " amount: ", ugnotCoin)
	bankerUser.SendCoins(bankerContract, admin, coinsToTransfer)
	return "charged"
}
