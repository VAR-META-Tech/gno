package registrar

import (
	"crypto/sha256"
	"encoding/hex"
)

func Get256String(input string) string {
	data := []byte(input)
	hashed := sha256.Sum256(data)
	hashedBytes := hashed[:]
	return hex.EncodeToString(hashedBytes)
}
