SWIFT_PATH := /usr/bin/swift

.PHONY: generate-api

generate-api:
	$(SWIFT_PATH) package plugin --allow-writing-to-package-directory generate-code-from-openapi RegistryAPI

generate-certificate:
	openssl req -x509 \
		-newkey rsa:4096 \
		-keyout swift-registry-key.key \
		-out swift-registry-certificate.crt \
		-days 365 \
		-noenc \
		-subj "/O=SwiftRegistry/CN=localhost"
