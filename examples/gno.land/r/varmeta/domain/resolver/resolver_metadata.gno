package resolver

import (
	"std"
	"time"

	"gno.land/p/varmeta/demo/v7/domain"
)

// Metadata wrapper
func metadataWrapper(owner std.Address, name string, ttl time.Duration) domain.Metadata {
	crrTime := time.Now()
	expTime := crrTime.Add(ttl)
	return domain.NewMetadata("", name, "", "", crrTime, expTime, []domain.Trait{})
}
