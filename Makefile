# Swift Birdhouse Makefile

docker-test:
	docker run --rm -v "$$PWD":/app -w /app swift:6.1.0 swift test

generate-certificate:
	openssl req -x509 \
		-newkey rsa:4096 \
		-keyout birdhouse-key.key \
		-out birdhouse-certificate.crt \
		-days 365 \
		-noenc \
		-subj "/C=AU/ST=Victoria/L=Melbourne/O=Birdhouse/CN=localhost"
