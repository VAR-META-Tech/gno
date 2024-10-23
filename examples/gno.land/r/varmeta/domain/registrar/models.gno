package registrar

import (
	"std"
)

type RequestInfo struct {
	Mode         string
	WantedDomain string
	Caller       std.Address
	TransInfo    TransferInfo
	// xxx extendTime, renew...
}
type TransferInfo struct {
	From std.Address
	To   std.Address
}
type ExecuteResult struct {
	Success       bool
	ResultDetails error
	Message       string
}
