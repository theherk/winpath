PHONY: all archives clean clean-build help lint test test-integration test-unit
.DEFAULT_GOAL := help

# project variables
PROJECT_NAME := winpath
VERSION := $(shell git describe --always --dirty)

# helper variables
BUILDDIR := ./_build
ARCDIR := $(BUILDDIR)/arc
BINDIR := $(BUILDDIR)/bin
LDFLAGS := "-X winpath.Version=$(VERSION)"

help:
	$(info available targets:)
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		nb = sub( /^## /, "", helpMsg ); \
		if(nb == 0) { \
			helpMsg = $$0; \
			nb = sub( /^[^:]*:.* ## /, "", helpMsg ); \
		} \
		if (nb) \
			print  $$1 "\t" helpMsg; \
	} \
	{ helpMsg = $$0 }' \
	$(MAKEFILE_LIST) | column -ts $$'\t' | \
	grep --color '^[^ ]*'

SYSTEMS := windows
ARCHS := 386 amd64

define PROGRAM_template
CUR = $(BINDIR)/$(PROJECT_NAME)_$(VERSION)_$(1)_$(2)/$(PROJECT_NAME)$(if $(filter windows,$(1)),.exe)
PROG_TARGETS += $(BINDIR)/$(PROJECT_NAME)_$(VERSION)_$(1)_$(2)/$(PROJECT_NAME)$(if $(filter windows,$(1)),.exe)
$(CUR): export GOOS = $(1)
$(CUR): export GOARCH = $(2)
ARC_TARGETS += $(ARCDIR)/$(PROJECT_NAME)_$(VERSION)_$(1)_$(2).zip
endef

$(foreach sys,$(SYSTEMS),$(foreach arch,$(ARCHS),$(eval $(call PROGRAM_template,$(sys),$(arch)))))

$(PROG_TARGETS):
	go build -i -v -ldflags=$(LDFLAGS) -o $@

$(ARCDIR)/%.zip: $(BINDIR)/%/*
	@mkdir -p $(ARCDIR)
	zip -j $@ $<

all: test $(PROG_TARGETS) archives ## build all systems and architectures

archives: $(ARC_TARGETS) ## archive all builds

clean: clean-build ## clean all

clean-build: ## remove build artifacts
	rm -rf $(BUILDDIR)

install: ## install to GOPATH
	go install -i -v -ldflags=$(LDFLAGS)

install-build-deps: ## install go dependencies
	go get ./...

install-test-deps: ## install go dependencies
	go get -t -tags '$(GO_BUILD_FLAGS)' ./...

lint: ## gofmt goimports
	gofmt *.go
	-goimport *.go

release: req-release-type req-release-repo clean ## package and upload a release
	release -t $(RELEASE_TYPE) -g $(RELEASE_REPO) $(RELEASE_BRANCH) $(RELEASE_BASE)

req-release-type:
ifndef RELEASE_TYPE
	$(error RELEASE_TYPE is undefined)
endif

req-release-repo:
ifndef RELEASE_REPO
	$(error RELEASE_REPO is undefined)
endif

test: test-unit ## run unit tests

test-all: test-unit test-integration

test-integration: export GO_BUILD_FLAGS = integration
test-integration: install-test-deps ## run integration tests
	go test -v -tags '$(GO_BUILD_FLAGS)' ./...

test-unit: export GO_BUILD_FLAGS = unit
test-unit: install-test-deps ## run unit tests
	go test -v -tags '$(GO_BUILD_FLAGS)' ./...
