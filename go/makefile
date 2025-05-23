ARTIFACT_DIR=dist
BINARY=scratchpad
VERSION=1.0.0
GOENV=CGO_ENABLED=0
GOOS=
GOARCH=
BUILD_FLAGS=-ldflags="-X 'main.Version=$(VERSION)'"
TEST_FLAGS=-cover -count 1

CLI=docker
ORG=clanktron
CONTAINERNAME=$(ORG)/$(BINARY)
CONTAINERTAG=dev

$(BINARY):
	GOOS=$(GOOS) GOARCH=$(GOARCH) $(GOENV) go build $(BUILD_FLAGS) -o $(BINARY) $(SRC) ## Build binary (default)

.PHONY: check
check: test lint ## Test and lint

.PHONY: test
test: ## Run go tests
	go test $(TEST_FLAGS) ./...

.PHONY: lint
lint: ## Run go vet and staticcheck against codebase
	go vet ./...
	staticcheck ./...

.PHONY: release-chart
package-chart: ## Package helm chart
	helm package -u ./chart -d $(ARTIFACT_DIR)

.PHONY: checksums
checksums: ## Generate release asset checksums
	shasum -a 256 $(ARTIFACT_DIR)/* | tee $(ARTIFACT_DIR)/checksums.txt

.PHONY: clean
clean: ## Clean workspace
	rm -rf $(BINARY) $(ARTIFACT_DIR)/*
	go clean

.PHONY: help
help:
	@echo "Available targets:"
	@if [ -t 1 ]; then \
		awk -F ':|##' '/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST) | grep -v '^help:'; \
	else \
		awk -F ':|##' '/^[a-zA-Z0-9_-]+:.*?##/ { printf "  %-20s %s\n", $$1, $$NF }' $(MAKEFILE_LIST) | grep -v '^help:'; \
	fi
