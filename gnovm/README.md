# GnoVM -- Gnolang Virtual Machine

GnoVM is a virtual machine that interprets Gnolang, a custom version of Golang optimized for blockchains, featuring automatic state management, full determinism, and idiomatic Go.
It works with Tendermint2 and enables smarter, more modular, and transparent appchains with embedded smart-contracts.
It can be used in TendermintCore, forks, and non-Cosmos blockchains.

Read the ["Intro to Gnoland"](https://gno.land/r/gnoland/blog:p/intro) blogpost.

This folder focuses on the VM, language, stdlibs, tests, and tools, independent of the blockchain.
This enables non-web3 developers to contribute without requiring an understanding of the broader context.

## Language Features

* Like interpreted Go, but more ambitious.
* Completely deterministic, for complete accountability.
* Transactional persistence across data realms.
* Designed for concurrent blockchain smart contracts systems.

## Getting started

Install [`gno`](./cmd/gno) and refer to the [`examples`](../examples) folder to start developing contracts.

Check the [Makefile](./Makefile) to enhance GnoVM, Gnolang, and stdlibs.

## Known Issues

* Switch varnames cannot be captured as heap items. [test](../gnovm/tests/files/closure11_known.gno)
<!-- BEGIN GENERATED PACKAGE LIST -->

* [github.com](./github.com)
  * [github.com/gnolang/gno/gnovm/cmd/benchops](./github.com/gnolang/gno/gnovm/cmd/benchops) - Package main has no documentation
  * [github.com/gnolang/gno/gnovm/cmd/gno](./github.com/gnolang/gno/gnovm/cmd/gno) - Package main has no documentation
  * [github.com/gnolang/gno/gnovm/cmd/gno/internal/pkgdownload](./github.com/gnolang/gno/gnovm/cmd/gno/internal/pkgdownload) - provides interfaces and utility functions to download gno packages files.
  * [github.com/gnolang/gno/gnovm/cmd/gno/internal/pkgdownload/examplespkgfetcher](./github.com/gnolang/gno/gnovm/cmd/gno/internal/pkgdownload/examplespkgfetcher) - provides an implementation of [pkgdownload.PackageFetcher]
  * [github.com/gnolang/gno/gnovm/cmd/gno/internal/pkgdownload/rpcpkgfetcher](./github.com/gnolang/gno/gnovm/cmd/gno/internal/pkgdownload/rpcpkgfetcher) - provides an implementation of [pkgdownload.PackageFetcher]
  * [github.com/gnolang/gno/gnovm/pkg/benchops](./github.com/gnolang/gno/gnovm/pkg/benchops) - Package benchops has no documentation
  * [github.com/gnolang/gno/gnovm/pkg/doc](./github.com/gnolang/gno/gnovm/pkg/doc) - implements support for documentation of Gno packages and realms,
  * [github.com/gnolang/gno/gnovm/pkg/gnoenv](./github.com/gnolang/gno/gnovm/pkg/gnoenv) - Package gnoenv has no documentation
  * [github.com/gnolang/gno/gnovm/pkg/gnofmt](./github.com/gnolang/gno/gnovm/pkg/gnofmt) - Package gnofmt has no documentation
  * [github.com/gnolang/gno/gnovm/pkg/gnolang](./github.com/gnolang/gno/gnovm/pkg/gnolang) - contains the implementation of the Gno Virtual Machine.
  * [github.com/gnolang/gno/gnovm/pkg/gnolang/internal/softfloat](./github.com/gnolang/gno/gnovm/pkg/gnolang/internal/softfloat) - is a copy of the Go runtime's softfloat64.go file.
  * [github.com/gnolang/gno/gnovm/pkg/gnolang/internal/softfloat/gen](./github.com/gnolang/gno/gnovm/pkg/gnolang/internal/softfloat/gen) - Package main has no documentation
  * [github.com/gnolang/gno/gnovm/pkg/gnolang/internal/txlog](./github.com/gnolang/gno/gnovm/pkg/gnolang/internal/txlog) - is an internal package containing data structures that can
  * [github.com/gnolang/gno/gnovm/pkg/gnomod](./github.com/gnolang/gno/gnovm/pkg/gnomod) - Package gnomod has no documentation
  * [github.com/gnolang/gno/gnovm/pkg/integration](./github.com/gnolang/gno/gnovm/pkg/integration) - Package integration has no documentation
  * [github.com/gnolang/gno/gnovm/pkg/packages](./github.com/gnolang/gno/gnovm/pkg/packages) - provides utility functions to statically analyze Gno MemPackages
  * [github.com/gnolang/gno/gnovm/pkg/repl](./github.com/gnolang/gno/gnovm/pkg/repl) - Package repl has no documentation
  * [github.com/gnolang/gno/gnovm/pkg/test](./github.com/gnolang/gno/gnovm/pkg/test) - contains the code to parse and execute Gno tests and filetests.
  * [github.com/gnolang/gno/gnovm/pkg/transpiler](./github.com/gnolang/gno/gnovm/pkg/transpiler) - implements a source-to-source compiler for translating Gno
  * [github.com/gnolang/gno/gnovm/pkg/version](./github.com/gnolang/gno/gnovm/pkg/version) - Package version has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs](./github.com/gnolang/gno/gnovm/stdlibs) - Package stdlibs has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs/crypto/ed25519](./github.com/gnolang/gno/gnovm/stdlibs/crypto/ed25519) - Package ed25519 has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs/crypto/sha256](./github.com/gnolang/gno/gnovm/stdlibs/crypto/sha256) - Package sha256 has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs/math](./github.com/gnolang/gno/gnovm/stdlibs/math) - Package math has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs/runtime](./github.com/gnolang/gno/gnovm/stdlibs/runtime) - Package runtime has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs/std](./github.com/gnolang/gno/gnovm/stdlibs/std) - Package std has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs/sys/params](./github.com/gnolang/gno/gnovm/stdlibs/sys/params) - Package params has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs/testing](./github.com/gnolang/gno/gnovm/stdlibs/testing) - Package testing has no documentation
  * [github.com/gnolang/gno/gnovm/stdlibs/time](./github.com/gnolang/gno/gnovm/stdlibs/time) - Package time has no documentation
  * [github.com/gnolang/gno/gnovm/tests/stdlibs](./github.com/gnolang/gno/gnovm/tests/stdlibs) - provides supplemental stdlibs for the testing environment.
  * [github.com/gnolang/gno/gnovm/tests/stdlibs/fmt](./github.com/gnolang/gno/gnovm/tests/stdlibs/fmt) - Package fmt has no documentation
  * [github.com/gnolang/gno/gnovm/tests/stdlibs/os](./github.com/gnolang/gno/gnovm/tests/stdlibs/os) - Package os has no documentation
  * [github.com/gnolang/gno/gnovm/tests/stdlibs/std](./github.com/gnolang/gno/gnovm/tests/stdlibs/std) - Package std has no documentation
  * [github.com/gnolang/gno/gnovm/tests/stdlibs/testing](./github.com/gnolang/gno/gnovm/tests/stdlibs/testing) - Package testing has no documentation
  * [github.com/gnolang/gno/gnovm/tests/stdlibs/unicode](./github.com/gnolang/gno/gnovm/tests/stdlibs/unicode) - Package unicode has no documentation

<!-- END GENERATED PACKAGE LIST -->