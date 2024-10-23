package registrar

// import (
// 	"std"

// 	"gno.land/p/demo/ufmt"
// 	pusers "gno.land/p/demo/users"
// 	"gno.land/r/varmeta/demo1/domain/vmt"
// )

// // expected approved already from client -> transfer from caller to admin
// func tokenProcess(dName string, callerStd std.Address) {
// 	caller := pusers.AddressOrName(callerStd.String())

// 	now := std.CurrentRealm().Addr()
// 	nowAddr := pusers.AddressOrName(now.String())
// 	ufmt.Println("current realm transfer: ", now.String())
// 	callerAllowance := vmt.Allowance(caller, nowAddr)
// 	callerAllowanceString := ufmt.Sprintf("%d", callerAllowance)
// 	ufmt.Println("caller allowance ", callerAllowanceString)

// 	adminAddr := pusers.AddressOrName(admin.String())
// 	ufmt.Println("admin: ", admin.String())
// 	vmt.TransferFrom(caller, adminAddr, 1)
// }
