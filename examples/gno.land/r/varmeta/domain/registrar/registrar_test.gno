package registrar

// import (
// 	"std"
// 	"testing"
// )

// func TestRegisterDomain(t *testing.T) {
// 	tcs := []struct {
// 		dName      string
// 		hashString string
// 		caller     string
// 		expected   string
// 	}{
// 		{"thinhnx.gno", "6c091667070fa0d70b8bab92755dec7af8d9adce498d08e18c6446e0d71d6cd9", "g162jgpk4740r6a7g53cgz9ahxqtyuekgqchw6w9", "committed hash"},
// 	}
// 	for tc := range tcs {
// 		name := tc.input
// 		t.Run(name, func(t *testing.T) {
// 			output := CommitHash(tc.dName, tc.hashString)
// 			if output != tc.expected {
// 				t.Errorf("Expected '%q, but got %q", tc.expected, output)
// 			}
// 			status := getCurrentStatus(tc.dName, tc.caller)
// 			if status != tc.expected {
// 				t.Errorf("got %q", status)
// 			}
// 		})
// 	}
// }
