# go option
GO        ?= $(shell which go)
ifeq ($(GO),)
$(error Please put go binary in path or set GO env variable with full path to binary)
endif
TAGS      :=
TESTS     := .
TESTFLAGS :=
LDFLAGS   := -w -s
GOFLAGS   :=
BINDIR    := $(CURDIR)/bin

BINARIES  := <space separated binaries>
PROJ_NAME := <golang project name>

CONTAINER_REGISTRY := <container registry if needed>
CONTAINER_REPOSITORY := <container repository if needed>
CONTAINER_NAME := <container name if needed>

CONTAINER_GO_BUILD := golang:1.12.7-alpine3.10
CONTAINER_RELEASE_SUPPORT := alpine:3.10.1
CONTAINER_USER := itavy
CONTAINER_MAINTAINER := "Octavian Ionescu <itavyg@gmail.com>"

GO_SRC_FILES := $(shell find . -name '*.go')

# proj details
BUILD_VERSION ?= v0.0.1

.PHONY: all
all: build

.PHONY: build
build: $(BINARIES)

.PHONY: $(BINARIES)
$(BINARIES): generate
	rm -rf $(BINDIR)/*
	GOBIN=$(BINDIR) $(GO) install $(GOFLAGS) -tags '$(TAGS)' -ldflags '$(LDFLAGS)' $(PROJ_NAME)/cmd/$@/...

.PHONY: generate
generate:
	$(GO) generate $(GOFLAGS) -tags '$(TAGS)' -ldflags '$(LDFLAGS)' $(PROJ_NAME)/cmd/$(BINARIES)/...

.PHONY: test
test: build
test: TESTFLAGS += -race -v
#test: test-style
test: test-unit


.PHONY: test-style
test-style:
  @scripts/validate-license.sh


.PHONY: test-unit
test-unit:
	@echo
	@echo "==> Running unit tests <=="
	$(GO) test $(GOFLAGS) -ldflags '$(LDFLAGS)' -run $(TESTS) $(PROJ_NAME)/cmd/... $(TESTFLAGS)

.PHONY: fmt
fmt:
	gofmt -w .

include version_helpers.mk
include tools.mk
include pre_commit_hook.mk
include container.mk

