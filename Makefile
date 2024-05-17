SWIFT_PATH := /usr/bin/swift

.PHONY: generate-api

generate-api:
	$(SWIFT_PATH) package plugin --allow-writing-to-package-directory generate-code-from-openapi RegistryAPI
