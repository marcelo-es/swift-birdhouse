SWIFT_PATH := /usr/bin/swift

.PHONY: generate-api

generate-api:
	$(SWIFT_PATH) package plugin --allow-writing-to-package-directory generate-code-from-openapi RegistryAPI

generate-certificate:
	openssl req -x509 \
		-newkey rsa:4096 \
		-keyout birdhouse-key.key \
		-out birdhouse-certificate.crt \
		-days 365 \
		-noenc \
		-subj "/C=AU/ST=Victoria/L=Melbourne/O=Birdhouse/CN=localhost"
