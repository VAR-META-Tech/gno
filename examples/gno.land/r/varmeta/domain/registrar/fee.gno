package registrar

import (
	"time"
)

// only admin can set Fee, other just can read only
type feeInfo struct {
	RegisterBaseFee     int64
	RenewalFee          int64
	RegisterAdditionFee int64
	BidJoinFee          int64
}

func GetRegisterFee(dName string) int64 {
	return fee.RegisterBaseFee
}

func GetRenewalFee(dName string, amount time.Duration) int64 {
	return fee.RenewalFee
}

// Admin set register fee and renewal fee
func AdminSetFee(regFee int64, renewFee int64) {
	// consider logic
	assertIsAdmin()
	fee.RegisterBaseFee = regFee
	fee.RenewalFee = renewFee
}

// simple err check
func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}
