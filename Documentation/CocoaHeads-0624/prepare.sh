#!/usr/bin/env bash

set -xe

# Cleaning swell
git -C ~/Developer/swell clean -ffdx

# Cleaning swift-figlet
git -C ~/Developer/swift-figlet clean -ffdx

# Restoring swift-figlet
git -C ~/Developer/swift-figlet restore .

# Purging cache
swift package --package-path ~/Developer/swift-figlet purge-cache

# Removing Fingerprints
rm ~/Library/org.swift.swiftpm/security/fingerprints/marcelo-es.swell.json
