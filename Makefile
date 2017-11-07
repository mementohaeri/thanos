PREFIX ?= $(shell pwd)
FILES ?= $(shell find . -type f -name '*.go' -not -path "./vendor/*")

all: install-tools format build

format:
	@echo ">> formatting code"
	@goimports -w $(FILES)

vet:
	@echo ">> vetting code"
	@go vet ./...

build:
	@echo ">> building binaries"
	@promu build --prefix $(PREFIX)

install-tools:
	@echo ">> fetching goimports"
	@go get -u golang.org/x/tools/cmd/goimports
	@echo ">> fetching promu"
	@go get -u github.com/prometheus/promu
	@echo ">> fetching dep"
	@go get -u github.com/golang/dep/cmd/dep

test-deps:
	@go get -u github.com/prometheus/prometheus/cmd/prometheus

proto:
	@go get -u github.com/gogo/protobuf/protoc-gen-gogofast
	@./scripts/genproto.sh

test: test-deps
	@echo ">> running all tests"
	@go test $(shell go list ./... | grep -v /vendor/)

.PHONY: all install-tools format vet build