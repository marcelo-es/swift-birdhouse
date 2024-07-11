![swift-birdhouse-logo-horizontal](https://github.com/marcelo-es/swift-birdhouse/assets/1888072/1414e829-d9de-4c60-a52a-ad6fdb5b56af)

A [Swift Registry](https://github.com/swiftlang/swift-package-manager/blob/main/Documentation/PackageRegistry/Registry.md), built with [Hummingbird](https://github.com/hummingbird-project/hummingbird).

> [!IMPORTANT]
> Swift Birdhouse, while functional, is still under heavy development and is not production-ready. See [ROADMAP](ROADMAP.md) for information on where it is and where it's going.

## Project Goals

- Be true to the [Swift Registry specs](https://github.com/swiftlang/swift-package-manager/blob/main/Documentation/PackageRegistry/Registry.md).
- Have as few dependencies as we can get away with.
- Be very fast on runtime.
- Adopt the latest Swift standards (Swifts should love their house).

## Running Swift Birdhouse

To run Swift Birdhouse locally:

```shell
$ swift run swift-birdhouse
```

This will fire up a server on `127.0.0.1` on port `8080`.

## Self-Signed Certificate

TLS is not a *strict* requirement from Swift 6 onwards, which has the option `--allow-insecure-http` on the `swift package-registry` commands.

But if, for any reason, it is required to run Swift Birdhouse over HTTPS, the Makefile target `generate-certificate` can create a simple self-signed certificate and private key. Make sure to add it to the Mac Keychain and trust it.

```shell
$ make generate-certificate
$ swift run birdhouse \
   --certificate ./birdhouse-certificate.crt \
   --private-key ./birdhouse-key.key
```
