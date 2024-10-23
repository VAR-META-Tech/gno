// /*
// 	this realm is implementaion of sealed bidding package, which object is domainName
// 	this realm charges fee itself and not relate to the logic of sealed bidding
// */

package sbidrealm

// import (
// 	"std"
// 	"time"

// 	"gno.land/p/demo/avl"
// 	"gno.land/p/demo/ufmt"
// 	"gno.land/p/varmeta/demo/v7/sbid"
// 	"gno.land/r/varmeta/demo/v7/domain/registrar"
// )

// func Render(path string) string {
// 	return "Welcome to varmeta realm bidding"
// }

// var (
// 	root     *avl.Tree // domainName <- *sbid.Bid{BidInfo}
// 	infoTree *avl.Tree // caller <- sbid.BidInfo
// )

// func init() {
// 	root = avl.NewTree()
// 	infoTree = avl.NewTree()
// }

// func newBid(domainName string) *sbid.Bid {
// 	now := time.Now().UnixMilli()
// 	endHashTime := time.Now().Add(30 * time.Second).UnixMilli()
// 	endPriceTime := time.Now().Add(60 * time.Second).UnixMilli()

// 	bid := &sbid.Bid{
// 		Infos:        infoTree,
// 		StartTime:    now,
// 		EndHashTime:  endHashTime,
// 		EndPriceTime: endPriceTime,
// 	}
// 	root.Set(domainName, bid)
// 	return bid
// }

// // getBid returns the existed pointer to bid session in root. if there isnt, it will create new bid session
// func getBid(domainName string) *sbid.Bid {
// 	var bid *sbid.Bid
// 	data, existed := root.Get(domainName)
// 	if !existed {
// 		ufmt.Println("create new bid")
// 		bid = newBid(domainName)
// 	}
// 	if existed {
// 		ufmt.Println("existed")
// 		bid = data.(*sbid.Bid)
// 	}
// 	return bid
// }

// func CommitHash(domainName string, hashString string) string {
// 	bid := getBid(domainName)
// 	caller := std.GetOrigCaller().String()
// 	// commit hash will also update info tree of the bid session
// 	return bid.CommitHash(domainName, hashString, caller)
// }

// func CommitPrice(domainName string, price int64, secret string) string {
// 	bid := getBid(domainName)
// 	caller := std.GetOrigCaller().String()
// 	return bid.CommitPrice(domainName, price, secret, caller)
// }

// func GetJoinedBid(caller string) []sbid.BidStatus {
// 	return findStatusInRoot(caller)
// }

// func findStatusInRoot(caller string) []sbid.BidStatus {
// 	listStt := []sbid.BidStatus{}
// 	root.Iterate("", "", func(key string, value interface{}) bool {
// 		bid := value.(*sbid.Bid)
// 		if bid.Infos.Has(caller) {
// 			stt := bid.GetStatus(key, caller)
// 			listStt = append(listStt, stt)
// 		}
// 		return false
// 	})
// 	return listStt
// }

// func GetCurrentStatus(dName string) string {
// 	owner := registrar.GetOwner(dName)
// 	if owner != "" {
// 		return "owned by " + owner.String()
// 	}
// 	bid := getBid(dName)
// 	caller := std.GetOrigCaller().String()
// 	status := bid.GetStatus(dName, caller)
// 	if status.Status == "free" {
// 		return "domain name is free"
// 	}
// 	// Auction closed with winner
// 	now := time.Now().UnixMilli()
// 	if bid.EndPriceTime <= now && owner != "" {
// 		return "close"
// 	}
// 	// both undefined
// 	return status.Status
// }

// func GetCurrentWinner(dName string) string {
// 	bid := getBid(dName)
// 	winner := bid.GetCurrentWinner()
// 	if winner == "" {
// 		return "no winner yet"
// 	}
// 	return winner
// }

// func now() int64 {
// 	return time.Now().UnixMilli()
// }

// func Claim(dName string) string {
// 	if !root.Has(dName) {
// 		panic("invalid domain name")
// 	}
// 	bid := getBid(dName)
// 	caller := std.GetOrigCaller()
// 	if caller.String() != bid.GetCurrentWinner() {
// 		panic("only winner can claim")
// 	}
// 	requestInfo := registrar.RequestInfo{
// 		WantedDomain: dName,
// 		Caller:       caller,
// 		Mode:         "native",
// 	}
// 	result := registrar.ExecuteRegisterNew(requestInfo)
// 	if !result.Success {
// 		panic("bad register")
// 	}
// 	return "claimed"
// }

// // func chargeFee(amount int64, from std.Address) string {
// // 	bankerContract := std.CurrentRealm().Addr()
// // 	ugnotCoin := std.NewCoin("ugnot", amount)
// // 	coinsToTransfer := std.NewCoins(ugnotCoin)
// // 	coins := checkCoin(from)
// // 	ufmt.Println("check balances: ", coins)
// // 	// ufmt.Println("send from contract ", bankerContract.String(), " to admin ", admin.String(), " amount: ", ugnotCoin)
// // 	bankerUser.SendCoins(bankerContract, admin, coinsToTransfer)
// // 	return "charged"
// // }
