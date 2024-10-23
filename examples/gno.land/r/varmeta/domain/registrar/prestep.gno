package registrar

import (
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/varmeta/demo/v7/domain"
)

var (
	domainStorage *avl.Tree // domainName -> std.Address
	rootRegistry  domain.DomainRegistry

	// fee
	superBanker std.Banker // full access to coins that the realm itself owns, including the ones sent with the transaction
	bankerUser  std.Banker // full access to coins sent with the transaction that called the banker

	admin    std.Address // admin
	adminVar std.Address // admin in server
	fee      feeInfo
)

func init() {
	domainStorage = avl.NewTree()
	// bidStorage = avl.NewTree()
	// winnerRec = avl.NewTree()
	// joinedBid = avl.NewTree()
	rootRegistry = domain.NewDomainRegistry("Varmeta", "vmt")

	// fee init
	admin = "g162jgpk4740r6a7g53cgz9ahxqtyuekgqchw6w9"    //@thinhnx
	adminVar = "g1p3ylc5w42lrt5345eh7h5l9gcd7qpeyvcl5qjx" //@varmeta-sponsorkey
	// ugnot
	fee = feeInfo{
		RegisterBaseFee:     100,
		RenewalFee:          100,
		RegisterAdditionFee: 0,
		BidJoinFee:          100,
	}
	superBanker = std.GetBanker(std.BankerTypeRealmSend)
	bankerUser = std.GetBanker(std.BankerTypeOrigSend)
}
