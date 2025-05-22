# Tendermint2

**Disclaimer: Tendermint2 is currently part of the Gno monorepo for streamlined development.**

**Once gno.land is on the mainnet, Tendermint2 will operate independently, including for governance, on https://github.com/tendermint/tendermint2.**

## Mission

* Make awesome software with modular components.
* Crypto P2P Swiss armyknife for human liberation.

## Problems

* Open source is open for subversion.
* Incentives and mission are misaligned.
* Need directory & forum for Tendermint/SDK forks.

## Partial Solution: adopt principles

* Simplicity of design.
* The code is the spec.
* Minimal code - keep total footprint small.
* Minimal dependencies - all dependencies must get audited, and become part of
  the repo.
* Modular dependencies - wherever reasonable, make components modular.
* Completeness - software projects that don't become finished are projects
  that are forever vulnerable. One of the primary goals of the Gno language
  and related works is to become finished within a reasonable timeframe.

## What is already proposed for Tendermint2:

* Complete Amino. -> multiplier of productivity for SDK development, to not
  have to think about protobuf at all. Use "genproto" to even auto-generate
  proto3 for encoding/decoding optimization through protoc.
    - MISSION: be the basis for improving the encoding standard from proto3, because
      proto3 length-prefixing is slow, and we need "proto4" or "amino2".
    - LOOK at the auto-generated proto files!
      https://github.com/gnolang/gno/blob/master/tm2/pkg/bft/consensus/types/cstypes.proto
      for example.
    - There was work to remove this from the CosmosSDK because
      Amino wasn't ready, but now that it is, it makes sense to incorporate it into
      Tendermint2.


* Remove EvidenceReactor, Evidence, Violation:
  
    We need to make it easy to create alt mempool reactors.

  We "kill two birds with one stone" by implementing evidence as a first-class mempool lane.

  The authors of "ABCI++" have a different set of problems to solve, so we should do both! Tendermint++
  and Tendermint2.


* Fix address size to 20 bytes -> 160 is sufficient, and fixing it brings optimizations.


* General versionset system for handshake negotiation. -> So Tendermint2 can be
  used as basis for other P2P applications.


* EventBus -> EventSwitch. -> For indexing, use an external system.

    To ensure Tendermint2 remains minimal and easily integrated with plugin modules, there is no internal implementation.

  The use of an EventSwitch makes the process simpler and synchronous, which maintains the determinism of Tendermint tests.

  Keeping the Tendermint protocol synchronous is sufficient for optimal performance.

  However, if there is a need for asynchronous processing due to an exceptionally large number of validators, it should be a separate fork with a unique name under the same taxonomy as Tendermint.


* Fix nondeterminism in consensus tests -> in relation to the above.

* Add "MaxDataBytes" for total tx data size limitation.

  To avoid unexpected behavior caused by changes in validator size, it's best to allocate room for each module separately instead of limiting the total block size as we did before. 

This way, we can ensure that there's enough space for all modules.

* Remove external dependencies like prometheus
  To ensure accuracy, all metrics and events should be integrated through interfaces. This may require extracting client logic from Prometheus, but it will be incorporated into Tendermint2 and undergo the same auditing process as everything else.

* General consensus/WAL -> a WAL is useful enough to warrant being a re-usable
  module.

* Remove GRPC -> GRPC support should be plugged in (say in a GRPC fork of
  Tendermint2), so alternative RPC protocols can likewise be. Tendermint2 aims
  to be independent of the Protobuf stack so that it can retain freedom for
  improving its codec.

* Remove dependency on viper/cobra -> I have tried to strip out what we don't
  use of viper/cobra for minimalism, but could not; and viper/cobra is one
  prime target for malware to be introduced. Rather than audit viper/cobra,
  Tendermint2 implements a cli convention for Go-structure-based flags and cli;
  so if you still want to use viper/cobra you can do so by translating flags to
  an options struct.

* Question: Which projects use ABCI sockets besides CosmosSDK derived chains?

## Roadmap

First, we create a multi-organizational team for Tendermint2 &
TendermintCore/++ development. We will maintain a fork of the Tendermint++ repo
and suggest changes upstream based on our work on Tendermint2, while also
porting necessary fixes from Tendermint++ over to Tendermint2.

We will also reach out to ecosystem partners and survey and create a
directory/taxonomy for Tendermint and CosmosSDK derivatives and manage a forum
for interfork collaboration.

Ideally, Tendermint2 and TendermintCore/++ merge into one.

## Challenge

Either make a PR to Gaia/CosmosSDK/TendermintCore to be like Tendermint2, or
make a PR to Tendermint2 to import a feature or fix of TendermintCore.
<!-- BEGIN GENERATED PACKAGE LIST -->

* [github.com](./github.com)
  * [github.com/gnolang/gno/tm2/pkg/amino](./github.com/gnolang/gno/tm2/pkg/amino) - // Package "pkg" exists So dependencies can create Packages.
  * [github.com/gnolang/gno/tm2/pkg/amino/cmd/aminoscan](./github.com/gnolang/gno/tm2/pkg/amino/cmd/aminoscan) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/cmd/goscan](./github.com/gnolang/gno/tm2/pkg/amino/cmd/goscan) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/gengo](./github.com/gnolang/gno/tm2/pkg/amino/gengo) - Package gengo has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/genproto](./github.com/gnolang/gno/tm2/pkg/amino/genproto) - Package genproto has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/genproto/example](./github.com/gnolang/gno/tm2/pkg/amino/genproto/example) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/genproto/example/submodule](./github.com/gnolang/gno/tm2/pkg/amino/genproto/example/submodule) - Package submodule has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/genproto/example/submodule2](./github.com/gnolang/gno/tm2/pkg/amino/genproto/example/submodule2) - Package submodule2 has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/genproto/stringutil](./github.com/gnolang/gno/tm2/pkg/amino/genproto/stringutil) - Package stringutil has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/libs/detrand](./github.com/gnolang/gno/tm2/pkg/amino/libs/detrand) - Package detrand has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/libs/press](./github.com/gnolang/gno/tm2/pkg/amino/libs/press) - Package press has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/pkg](./github.com/gnolang/gno/tm2/pkg/amino/pkg) - // Package dependencies need to be declared (for now).
  * [github.com/gnolang/gno/tm2/pkg/amino/tests](./github.com/gnolang/gno/tm2/pkg/amino/tests) - Package tests has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/tests/cmd](./github.com/gnolang/gno/tm2/pkg/amino/tests/cmd) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/binary](./github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/binary) - Package fuzzbinary has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/binary/debug](./github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/binary/debug) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/binary/init-corpus](./github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/binary/init-corpus) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/json](./github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/json) - Package fuzzjson has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/json/debug](./github.com/gnolang/gno/tm2/pkg/amino/tests/fuzz/json/debug) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/tests/pb](./github.com/gnolang/gno/tm2/pkg/amino/tests/pb) - Package pb has no documentation
  * [github.com/gnolang/gno/tm2/pkg/amino/tests/proto3/proto](./github.com/gnolang/gno/tm2/pkg/amino/tests/proto3/proto) - Package proto3 has no documentation
  * [github.com/gnolang/gno/tm2/pkg/async](./github.com/gnolang/gno/tm2/pkg/async) - Package async has no documentation
  * [github.com/gnolang/gno/tm2/pkg/autofile](./github.com/gnolang/gno/tm2/pkg/autofile) - Package autofile has no documentation
  * [github.com/gnolang/gno/tm2/pkg/autofile/cmd](./github.com/gnolang/gno/tm2/pkg/autofile/cmd) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bech32](./github.com/gnolang/gno/tm2/pkg/bech32) - Package bech32 has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/abci/client](./github.com/gnolang/gno/tm2/pkg/bft/abci/client) - Package abcicli has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/abci/example/counter](./github.com/gnolang/gno/tm2/pkg/bft/abci/example/counter) - Package counter has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/abci/example/errors](./github.com/gnolang/gno/tm2/pkg/bft/abci/example/errors) - Package errors has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/abci/example/kvstore](./github.com/gnolang/gno/tm2/pkg/bft/abci/example/kvstore) - Package kvstore has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/abci/types](./github.com/gnolang/gno/tm2/pkg/bft/abci/types) - Package abci has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/abci/version](./github.com/gnolang/gno/tm2/pkg/bft/abci/version) - Package abciver has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/appconn](./github.com/gnolang/gno/tm2/pkg/bft/appconn) - manages the connection of Tendermint to the application layer.
  * [github.com/gnolang/gno/tm2/pkg/bft/blockchain](./github.com/gnolang/gno/tm2/pkg/bft/blockchain) - Package blockchain has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/blockchain/version](./github.com/gnolang/gno/tm2/pkg/bft/blockchain/version) - Package bcver has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/config](./github.com/gnolang/gno/tm2/pkg/bft/config) - Package config has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/consensus](./github.com/gnolang/gno/tm2/pkg/bft/consensus) - Package consensus has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/consensus/config](./github.com/gnolang/gno/tm2/pkg/bft/consensus/config) - Package config has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/consensus/types](./github.com/gnolang/gno/tm2/pkg/bft/consensus/types) - Package cstypes has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/fail](./github.com/gnolang/gno/tm2/pkg/bft/fail) - Package fail has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/mempool](./github.com/gnolang/gno/tm2/pkg/bft/mempool) - Package mempool has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/mempool/config](./github.com/gnolang/gno/tm2/pkg/bft/mempool/config) - Package config has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/mempool/mock](./github.com/gnolang/gno/tm2/pkg/bft/mempool/mock) - Package mock has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/node](./github.com/gnolang/gno/tm2/pkg/bft/node) - Package node has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/privval](./github.com/gnolang/gno/tm2/pkg/bft/privval) - Package privval has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/proxy](./github.com/gnolang/gno/tm2/pkg/bft/proxy) - Package proxy has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/client](./github.com/gnolang/gno/tm2/pkg/bft/rpc/client) - provides a general purpose interface (Client) for connecting
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/config](./github.com/gnolang/gno/tm2/pkg/bft/rpc/config) - Package config has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/core](./github.com/gnolang/gno/tm2/pkg/bft/rpc/core) - Package core has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/core/types](./github.com/gnolang/gno/tm2/pkg/bft/rpc/core/types) - Package core_types has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/lib](./github.com/gnolang/gno/tm2/pkg/bft/rpc/lib) - Package rpc has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/client](./github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/client) - Package rpcclient has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/client/batch](./github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/client/batch) - Package batch has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/client/http](./github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/client/http) - Package http has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/client/ws](./github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/client/ws) - Package ws has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/server](./github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/server) - Package rpcserver has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/types](./github.com/gnolang/gno/tm2/pkg/bft/rpc/lib/types) - Package rpctypes has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/state](./github.com/gnolang/gno/tm2/pkg/bft/state) - Package state has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/state/eventstore](./github.com/gnolang/gno/tm2/pkg/bft/state/eventstore) - Package eventstore has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/state/eventstore/file](./github.com/gnolang/gno/tm2/pkg/bft/state/eventstore/file) - Package file has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/state/eventstore/null](./github.com/gnolang/gno/tm2/pkg/bft/state/eventstore/null) - Package null has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/state/eventstore/types](./github.com/gnolang/gno/tm2/pkg/bft/state/eventstore/types) - Package types has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/store](./github.com/gnolang/gno/tm2/pkg/bft/store) - Package store has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/types](./github.com/gnolang/gno/tm2/pkg/bft/types) - Package types has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/types/time](./github.com/gnolang/gno/tm2/pkg/bft/types/time) - Package time has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/types/version](./github.com/gnolang/gno/tm2/pkg/bft/types/version) - Package version has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/version](./github.com/gnolang/gno/tm2/pkg/bft/version) - Package version has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bft/wal](./github.com/gnolang/gno/tm2/pkg/bft/wal) - Package wal has no documentation
  * [github.com/gnolang/gno/tm2/pkg/bitarray](./github.com/gnolang/gno/tm2/pkg/bitarray) - Package bitarray has no documentation
  * [github.com/gnolang/gno/tm2/pkg/clist](./github.com/gnolang/gno/tm2/pkg/clist) - Package clist has no documentation
  * [github.com/gnolang/gno/tm2/pkg/cmap](./github.com/gnolang/gno/tm2/pkg/cmap) - Package cmap has no documentation
  * [github.com/gnolang/gno/tm2/pkg/colors](./github.com/gnolang/gno/tm2/pkg/colors) - Package colors has no documentation
  * [github.com/gnolang/gno/tm2/pkg/commands](./github.com/gnolang/gno/tm2/pkg/commands) - Package commands has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto](./github.com/gnolang/gno/tm2/pkg/crypto) - Package crypto has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/armor](./github.com/gnolang/gno/tm2/pkg/crypto/armor) - Package armor has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/bcrypt](./github.com/gnolang/gno/tm2/pkg/crypto/bcrypt) - implements Provos and Mazières's bcrypt adaptive hashing
  * [github.com/gnolang/gno/tm2/pkg/crypto/bip39](./github.com/gnolang/gno/tm2/pkg/crypto/bip39) - Package bip39 has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/ed25519](./github.com/gnolang/gno/tm2/pkg/crypto/ed25519) - Package ed25519 has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/hd](./github.com/gnolang/gno/tm2/pkg/crypto/hd) - provides basic functionality Hierarchical Deterministic Wallets.
  * [github.com/gnolang/gno/tm2/pkg/crypto/internal/benchmarking](./github.com/gnolang/gno/tm2/pkg/crypto/internal/benchmarking) - Package benchmarking has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/internal/ledger](./github.com/gnolang/gno/tm2/pkg/crypto/internal/ledger) - contains the internals for package crypto/keys/ledger,
  * [github.com/gnolang/gno/tm2/pkg/crypto/keys](./github.com/gnolang/gno/tm2/pkg/crypto/keys) - Package keys has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/keys/armor](./github.com/gnolang/gno/tm2/pkg/crypto/keys/armor) - Package armor has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/keys/client](./github.com/gnolang/gno/tm2/pkg/crypto/keys/client) - Package client has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/keys/keyerror](./github.com/gnolang/gno/tm2/pkg/crypto/keys/keyerror) - Package keyerror has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/ledger](./github.com/gnolang/gno/tm2/pkg/crypto/ledger) - Package ledger has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/merkle](./github.com/gnolang/gno/tm2/pkg/crypto/merkle) - Package merkle has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/mock](./github.com/gnolang/gno/tm2/pkg/crypto/mock) - Package mock has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/multisig](./github.com/gnolang/gno/tm2/pkg/crypto/multisig) - Package multisig has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/multisig/bitarray](./github.com/gnolang/gno/tm2/pkg/crypto/multisig/bitarray) - Package bitarray has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/secp256k1](./github.com/gnolang/gno/tm2/pkg/crypto/secp256k1) - Package secp256k1 has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/secp256k1/internal/secp256k1](./github.com/gnolang/gno/tm2/pkg/crypto/secp256k1/internal/secp256k1) - wraps the bitcoin secp256k1 C library.
  * [github.com/gnolang/gno/tm2/pkg/crypto/tmhash](./github.com/gnolang/gno/tm2/pkg/crypto/tmhash) - Package tmhash has no documentation
  * [github.com/gnolang/gno/tm2/pkg/crypto/xchacha20poly1305](./github.com/gnolang/gno/tm2/pkg/crypto/xchacha20poly1305) - creates an AEAD using hchacha, chacha, and poly1305
  * [github.com/gnolang/gno/tm2/pkg/crypto/xsalsa20symmetric](./github.com/gnolang/gno/tm2/pkg/crypto/xsalsa20symmetric) - Package xsalsa20symmetric has no documentation
  * [github.com/gnolang/gno/tm2/pkg/db](./github.com/gnolang/gno/tm2/pkg/db) - Package db has no documentation
  * [github.com/gnolang/gno/tm2/pkg/db/boltdb](./github.com/gnolang/gno/tm2/pkg/db/boltdb) - Package boltdb has no documentation
  * [github.com/gnolang/gno/tm2/pkg/db/goleveldb](./github.com/gnolang/gno/tm2/pkg/db/goleveldb) - Package goleveldb has no documentation
  * [github.com/gnolang/gno/tm2/pkg/db/internal](./github.com/gnolang/gno/tm2/pkg/db/internal) - exposes internal functions used within db packages.
  * [github.com/gnolang/gno/tm2/pkg/db/memdb](./github.com/gnolang/gno/tm2/pkg/db/memdb) - Package memdb has no documentation
  * [github.com/gnolang/gno/tm2/pkg/errors](./github.com/gnolang/gno/tm2/pkg/errors) - Package errors has no documentation
  * [github.com/gnolang/gno/tm2/pkg/events](./github.com/gnolang/gno/tm2/pkg/events) - - Pub-Sub in go with event caching
  * [github.com/gnolang/gno/tm2/pkg/flow](./github.com/gnolang/gno/tm2/pkg/flow) - provides the tools for monitoring and limiting the flow rate
  * [github.com/gnolang/gno/tm2/pkg/iavl](./github.com/gnolang/gno/tm2/pkg/iavl) - implements a versioned, snapshottable (immutable) AVL+ tree
  * [github.com/gnolang/gno/tm2/pkg/iavl/cmd/iaviewer](./github.com/gnolang/gno/tm2/pkg/iavl/cmd/iaviewer) - Package main has no documentation
  * [github.com/gnolang/gno/tm2/pkg/iavl/common](./github.com/gnolang/gno/tm2/pkg/iavl/common) - Package common has no documentation
  * [github.com/gnolang/gno/tm2/pkg/internal/p2p](./github.com/gnolang/gno/tm2/pkg/internal/p2p) - contains testing code that is moved over, and adapted from p2p/test_utils.go.
  * [github.com/gnolang/gno/tm2/pkg/log](./github.com/gnolang/gno/tm2/pkg/log) - Package log has no documentation
  * [github.com/gnolang/gno/tm2/pkg/os](./github.com/gnolang/gno/tm2/pkg/os) - Package os has no documentation
  * [github.com/gnolang/gno/tm2/pkg/overflow](./github.com/gnolang/gno/tm2/pkg/overflow) - offers overflow-checked integer arithmetic operations
  * [github.com/gnolang/gno/tm2/pkg/p2p](./github.com/gnolang/gno/tm2/pkg/p2p) - Package p2p has no documentation
  * [github.com/gnolang/gno/tm2/pkg/p2p/config](./github.com/gnolang/gno/tm2/pkg/p2p/config) - Package config has no documentation
  * [github.com/gnolang/gno/tm2/pkg/p2p/conn](./github.com/gnolang/gno/tm2/pkg/p2p/conn) - Package conn has no documentation
  * [github.com/gnolang/gno/tm2/pkg/p2p/dial](./github.com/gnolang/gno/tm2/pkg/p2p/dial) - contains an implementation of a thread-safe priority dial queue. The queue is sorted by
  * [github.com/gnolang/gno/tm2/pkg/p2p/discovery](./github.com/gnolang/gno/tm2/pkg/p2p/discovery) - contains the p2p peer discovery service (Reactor).
  * [github.com/gnolang/gno/tm2/pkg/p2p/events](./github.com/gnolang/gno/tm2/pkg/p2p/events) - contains a simple p2p event system implementation, that simplifies asynchronous event flows in the
  * [github.com/gnolang/gno/tm2/pkg/p2p/mock](./github.com/gnolang/gno/tm2/pkg/p2p/mock) - Package mock has no documentation
  * [github.com/gnolang/gno/tm2/pkg/p2p/types](./github.com/gnolang/gno/tm2/pkg/p2p/types) - Package types has no documentation
  * [github.com/gnolang/gno/tm2/pkg/p2p/version](./github.com/gnolang/gno/tm2/pkg/p2p/version) - Package p2pver has no documentation
  * [github.com/gnolang/gno/tm2/pkg/random](./github.com/gnolang/gno/tm2/pkg/random) - Package random has no documentation
  * [github.com/gnolang/gno/tm2/pkg/sdk](./github.com/gnolang/gno/tm2/pkg/sdk) - Package sdk has no documentation
  * [github.com/gnolang/gno/tm2/pkg/sdk/auth](./github.com/gnolang/gno/tm2/pkg/sdk/auth) - Package auth has no documentation
  * [github.com/gnolang/gno/tm2/pkg/sdk/bank](./github.com/gnolang/gno/tm2/pkg/sdk/bank) - Package bank has no documentation
  * [github.com/gnolang/gno/tm2/pkg/sdk/config](./github.com/gnolang/gno/tm2/pkg/sdk/config) - Package config has no documentation
  * [github.com/gnolang/gno/tm2/pkg/sdk/params](./github.com/gnolang/gno/tm2/pkg/sdk/params) - provides a lightweight implementation inspired by the x/params
  * [github.com/gnolang/gno/tm2/pkg/sdk/testutils](./github.com/gnolang/gno/tm2/pkg/sdk/testutils) - Package testutils has no documentation
  * [github.com/gnolang/gno/tm2/pkg/service](./github.com/gnolang/gno/tm2/pkg/service) - Package service has no documentation
  * [github.com/gnolang/gno/tm2/pkg/std](./github.com/gnolang/gno/tm2/pkg/std) - Package std has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store](./github.com/gnolang/gno/tm2/pkg/store) - Package store has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/cache](./github.com/gnolang/gno/tm2/pkg/store/cache) - Package cache has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/cachemulti](./github.com/gnolang/gno/tm2/pkg/store/cachemulti) - Package cachemulti has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/dbadapter](./github.com/gnolang/gno/tm2/pkg/store/dbadapter) - Package dbadapter has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/errors](./github.com/gnolang/gno/tm2/pkg/store/errors) - Package errors has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/gas](./github.com/gnolang/gno/tm2/pkg/store/gas) - Package gas has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/iavl](./github.com/gnolang/gno/tm2/pkg/store/iavl) - Package iavl has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/immut](./github.com/gnolang/gno/tm2/pkg/store/immut) - Package immut has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/prefix](./github.com/gnolang/gno/tm2/pkg/store/prefix) - Package prefix has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/rootmulti](./github.com/gnolang/gno/tm2/pkg/store/rootmulti) - Package rootmulti has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/types](./github.com/gnolang/gno/tm2/pkg/store/types) - Package types has no documentation
  * [github.com/gnolang/gno/tm2/pkg/store/utils](./github.com/gnolang/gno/tm2/pkg/store/utils) - Package utils has no documentation
  * [github.com/gnolang/gno/tm2/pkg/strings](./github.com/gnolang/gno/tm2/pkg/strings) - Package strings has no documentation
  * [github.com/gnolang/gno/tm2/pkg/telemetry](./github.com/gnolang/gno/tm2/pkg/telemetry) - Package telemetry has no documentation
  * [github.com/gnolang/gno/tm2/pkg/telemetry/config](./github.com/gnolang/gno/tm2/pkg/telemetry/config) - Package config has no documentation
  * [github.com/gnolang/gno/tm2/pkg/telemetry/metrics](./github.com/gnolang/gno/tm2/pkg/telemetry/metrics) - Package metrics has no documentation
  * [github.com/gnolang/gno/tm2/pkg/testutils](./github.com/gnolang/gno/tm2/pkg/testutils) - Package testutils has no documentation
  * [github.com/gnolang/gno/tm2/pkg/timer](./github.com/gnolang/gno/tm2/pkg/timer) - Package timer has no documentation
  * [github.com/gnolang/gno/tm2/pkg/versionset](./github.com/gnolang/gno/tm2/pkg/versionset) - Package versionset has no documentation

<!-- END GENERATED PACKAGE LIST -->