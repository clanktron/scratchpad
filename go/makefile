BINARY_NAME=scratchpad
ORG=clanktron
VERSION=1.0.0
GOENV=CGO_ENABLED=0
BUILD_FLAGS=-ldflags="-X 'main.Version=$(VERSION)'"
# TEST_FLAGS=-cover -count 1
ARTIFACT_DIR=dist

CLI=docker
CONTAINERNAME=$(ORG)/$(BINARY_NAME)
CONTAINERTAG=dev

PLATFORMS=linux/arm64,linux/amd64,linux/arm/v7,linux/riscv64

$(BINARY_NAME):
	$(GOENV) go build $(BUILD_FLAGS) -o $(BINARY_NAME) $(SRC) ## Build binary (default)

.PHONY: check
check: test lint ## Test and lint

.PHONY: test
test: ## Run go tests
	go test $(TEST_FLAGS) ./...

.PHONY: lint
lint: ## Run go vet and staticcheck against codebase
	go vet ./...
	staticcheck ./...

.PHONY: build-container
build-container: clean ## Build the container
	$(CLI) buildx build -t $(CONTAINERNAME):$(CONTAINERTAG) . -o dist -o type=docker

.PHONY: build-container-multiarch
build-container-multiarch: clean ## Build the container
	$(CLI) buildx build -t $(CONTAINERNAME):$(CONTAINERTAG) . --platform $(PLATFORMS)

.PHONY: build-container-multiarch-output
build-container-multiarch-output: clean ## Build the container
	$(CLI) buildx build -t $(CONTAINERNAME):$(CONTAINERTAG) . --platform $(PLATFORMS) -o dist
	
.PHONY: push-container
push-container: ## Push the container
	$(CLI) push $(CONTAINERNAME):$(CONTAINERTAG)

.PHONY: container-push
build-and-push-container: build-container push-container ## Build and push the container

.PHONY: dependencies
dependencies: ## Run go mod and go get to ensure dependencies
	go mod tidy && go get -v -d ./...

.PHONY: release-chart
package-chart: ## Package helm chart
	helm package -u ./chart -d $(ARTIFACT_DIR)

.PHONY: checksums
checksums: ## Generate release asset checksums
	shasum -a 256 $(ARTIFACT_DIR)/* | tee $(ARTIFACT_DIR)/checksums.txt

.PHONY: clean
clean: ## Clean workspace
	rm -rf $(BINARY_NAME) $(ARTIFACT_DIR)/*

.PHONY: help
help:
	@echo "Available targets:"
	@if [ -t 1 ]; then \
		awk -F ':|##' '/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST) | grep -v '^help:'; \
	else \
		awk -F ':|##' '/^[a-zA-Z0-9_-]+:.*?##/ { printf "  %-20s %s\n", $$1, $$NF }' $(MAKEFILE_LIST) | grep -v '^help:'; \
	fi
