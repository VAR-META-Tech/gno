package registrar

import "std"

type bidStatus struct {
	DomainName    string
	Status        string
	EndCommitTime int64
	EndPriceTime  int64
	ActiveUsers   int64
}

type bidRecord struct {
	DomainName       string
	Bidder           std.Address
	HashString       string
	Price            int64
	StartTime        int64
	EndCommitTime    int64
	EndPriceTime     int64
	IsCommittedPrice bool
	// CurrentPhase  actionCode
}
type bidRecV2 struct {
	DomainName       string
	Bidder           string
	HashString       string
	Price            int64
	StartTime        int64
	EndCommitTime    int64
	EndPriceTime     int64
	IsCommittedPrice bool
	IsCommittedHash  bool
	IsWinner         bool
}
