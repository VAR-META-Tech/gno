package gnoland

import (
	"errors"

	"github.com/gnolang/gno/tm2/pkg/std"
)

var (
	ErrBalanceEmptyAddress = errors.New("balance address is empty")
	ErrBalanceEmptyAmount  = errors.New("balance amount is empty")
)

type GnoAccount struct {
	std.BaseAccount
}

func ProtoGnoAccount() std.Account {
	return &GnoAccount{}
}

func ProtoGnoTotalCoin() std.Coin {
	return std.Coin{}
}

type GnoGenesisState struct {
	Balances []Balance `json:"balances"`
	Txs      []std.Tx  `json:"txs"`
}
