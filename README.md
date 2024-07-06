# Swift Registry

A Swift registry, built with Hummingbird.

## TLS

While TLS is not a requirement to run the project, SwiftPM will only connect to Swift Registry over https.

To run the service locally on SSL, generate a self-signed certificate through `make generate-certificate`, which will create `swift-registry-certificate.crt` and `swift-registry-key.key` on the root folder for you. Add it to your KeyChain and trust it. Then specify the certificate on launch time.

```bash
make generate-certificate

swift run swift-registry \
   --certificate ./swift-registry-certificate.crt \
   --private-key ./swift-registry-key.key
```
