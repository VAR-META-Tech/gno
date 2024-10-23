package registrar

import (
	"std"

	"gno.land/p/demo/ufmt"
)

// admin access only
func AdminWithdraw(amount int64) {
	assertIsAdmin()
	thisContract := std.CurrentRealm().Addr()
	ugnotCoin := std.NewCoin("ugnot", fee.RegisterBaseFee)
	coinsToTransfer := std.NewCoins(ugnotCoin)
	superBanker.SendCoins(thisContract, admin, coinsToTransfer)
}

func nativeProcess() {
	bankerContract := std.CurrentRealm().Addr()
	ugnotCoin := std.NewCoin("ugnot", fee.RegisterBaseFee)
	coinsToTransfer := std.NewCoins(ugnotCoin)
	caller := std.GetOrigCaller()
	coins := checkCoin(caller)
	ufmt.Println("check: ", coins)
	ufmt.Println("send from contract ", bankerContract.String(), " to admin ", admin.String(), " amount: ", ugnotCoin)
	bankerUser.SendCoins(bankerContract, admin, coinsToTransfer)
}

// RevertTransfer will revert the transaction - send amount of coin to user
func revertTransfer(userAddr std.Address) {
	bankerContract := std.CurrentRealm().Addr()
	ugnotCoin := std.NewCoin("ugnot", fee.RegisterBaseFee)
	coinsToReturn := std.NewCoins(ugnotCoin)
	ufmt.Println("return coins from contract ", bankerContract.String(), " to ", userAddr.String())
	bankerUser.SendCoins(bankerContract, userAddr, coinsToReturn)
}

// simple check for admin call
func assertIsAdmin() {
	// check if GetCallerAt 2 or 3 when deployed
	caller := std.GetCallerAt(3)
	err := ufmt.Sprintf("unauthorize with caller: %s\n", caller)
	if caller != admin && caller != adminVar {
		panic(err)
	}
}

// checking for availble coins
func checkCoin(from std.Address) std.Coins {
	// caller := std.GetOrigCaller()
	return bankerUser.GetCoins(from)
}
