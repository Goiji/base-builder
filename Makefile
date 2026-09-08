.PHONY: build test fmt deploy

build:
	forge build

test:
	forge test

fmt:
	forge fmt

deploy: ; @echo "Use forge script with a matching target"
