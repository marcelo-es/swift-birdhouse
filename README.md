![swift-birdhouse-logo-horizontal](https://github.com/marcelo-es/swift-birdhouse/assets/1888072/1414e829-d9de-4c60-a52a-ad6fdb5b56af)

A Swift Registry server built with Hummingbird.

## TLS

While TLS is not a requirement to run the project, SwiftPM will only connect to Swift Birdhouse over https.

To run the service locally on SSL, generate a self-signed certificate through `make generate-certificate`, which will create `birdhouse-certificate.crt` and `birdhouse-key.key` on the root folder for you. Add it to your KeyChain and trust it. Then specify the certificate on launch time.

```bash
make generate-certificate

swift run birdhouse \
   --certificate ./birdhouse-certificate.crt \
   --private-key ./birdhouse-key.key
```
