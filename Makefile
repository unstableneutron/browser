# Variables
# ---------

ZIG := zig
BC := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
# option test filter make test F="server"
F=
# Use curl-impersonate for TLS fingerprinting: USE_CURL_IMPERSONATE=1 make build
USE_CURL_IMPERSONATE ?= 0
ZIG_CURL_FLAG := $(if $(filter 1,$(USE_CURL_IMPERSONATE)),-Duse_curl_impersonate=true,)

# OS and ARCH
kernel = $(shell uname -ms)
ifeq ($(kernel), Darwin arm64)
	OS := macos
	ARCH := aarch64
else ifeq ($(kernel), Darwin x86_64)
	OS := macos
	ARCH := x86_64
else ifeq ($(kernel), Linux aarch64)
	OS := linux
	ARCH := aarch64
else ifeq ($(kernel), Linux arm64)
	OS := linux
	ARCH := aarch64
else ifeq ($(kernel), Linux x86_64)
	OS := linux
	ARCH := x86_64
else
	$(error "Unhandled kernel: $(kernel)")
endif


# Infos
# -----
.PHONY: help

## Display this help screen
help:
	@printf "\033[36m%-35s %s\033[0m\n" "Command" "Usage"
	@sed -n -e '/^## /{'\
		-e 's/## //g;'\
		-e 'h;'\
		-e 'n;'\
		-e 's/:.*//g;'\
		-e 'G;'\
		-e 's/\n/ /g;'\
		-e 'p;}' Makefile | awk '{printf "\033[33m%-35s\033[0m%s\n", $$1, substr($$0,length($$1)+1)}'


# $(ZIG) commands
# ------------
.PHONY: build build-v8-snapshot build-dev run run-release test bench data end2end install-curl-impersonate download-curl-impersonate build-curl-impersonate clean-curl-impersonate

## Build v8 snapshot
build-v8-snapshot:
	@printf "\033[36mBuilding v8 snapshot (release safe$(if $(filter 1,$(USE_CURL_IMPERSONATE)), + curl-impersonate,))...\033[0m\n"
	@$(ZIG) build -Doptimize=ReleaseFast $(ZIG_CURL_FLAG) snapshot_creator -- src/snapshot.bin || (printf "\033[33mBuild ERROR\033[0m\n"; exit 1;)
	@printf "\033[33mBuild OK\033[0m\n"

## Build in release-fast mode
build: build-v8-snapshot
	@printf "\033[36mBuilding (release fast$(if $(filter 1,$(USE_CURL_IMPERSONATE)), + curl-impersonate,))...\033[0m\n"
	@$(ZIG) build -Doptimize=ReleaseFast $(ZIG_CURL_FLAG) -Dsnapshot_path=../../snapshot.bin || (printf "\033[33mBuild ERROR\033[0m\n"; exit 1;)
	@printf "\033[33mBuild OK\033[0m\n"

## Build in debug mode
build-dev:
	@printf "\033[36mBuilding (debug$(if $(filter 1,$(USE_CURL_IMPERSONATE)), + curl-impersonate,))...\033[0m\n"
	@$(ZIG) build $(ZIG_CURL_FLAG) || (printf "\033[33mBuild ERROR\033[0m\n"; exit 1;)
	@printf "\033[33mBuild OK\033[0m\n"

## Run the server in release mode
run: build
	@printf "\033[36mRunning...\033[0m\n"
	@./zig-out/bin/lightpanda || (printf "\033[33mRun ERROR\033[0m\n"; exit 1;)

## Run the server in debug mode
run-debug: build-dev
	@printf "\033[36mRunning...\033[0m\n"
	@./zig-out/bin/lightpanda || (printf "\033[33mRun ERROR\033[0m\n"; exit 1;)

## Test - `grep` is used to filter out the huge compile command on build
ifeq ($(OS), macos)
test:
	@script -q /dev/null sh -c 'TEST_FILTER="${F}" $(ZIG) build test $(ZIG_CURL_FLAG) -freference-trace' 2>&1 \
		| grep --line-buffered -v "^/.*zig test -freference-trace"
else
test:
	@script -qec 'TEST_FILTER="${F}" $(ZIG) build test $(ZIG_CURL_FLAG) -freference-trace' /dev/null 2>&1 \
		| grep --line-buffered -v "^/.*zig test -freference-trace"
endif

## Run demo/runner end to end tests
end2end:
	@test -d ../demo
	cd ../demo && go run runner/main.go

# Install and build required dependencies commands
# ------------
.PHONY: install

install: build

# curl-impersonate (for TLS fingerprinting)
# -----------------------------------------
CURL_IMP := $(BC)vendor/curl-impersonate/out/$(OS)-$(ARCH)
CURL_IMP_BUILD := $(BC)vendor/curl-impersonate/build/$(OS)-$(ARCH)
CURL_IMP_CMAKE_ARGS := -DCMAKE_INSTALL_PREFIX=$(CURL_IMP) -DCMAKE_INSTALL_LIBDIR=lib
CURL_IMP_VERSION := v2.0.0a4-lightpanda.wsstartframe.1
CURL_IMP_ASSET_TARGET :=
ifeq ($(OS)-$(ARCH),macos-aarch64)
CURL_IMP_ASSET_TARGET := arm64-macos
endif
ifeq ($(OS)-$(ARCH),macos-x86_64)
CURL_IMP_ASSET_TARGET := x86_64-macos
endif
ifeq ($(OS)-$(ARCH),linux-aarch64)
CURL_IMP_ASSET_TARGET := aarch64-linux-gnu
endif
ifeq ($(OS)-$(ARCH),linux-x86_64)
CURL_IMP_ASSET_TARGET := x86_64-linux-gnu
endif
CURL_IMP_LIB_ASSET := libcurl-impersonate-$(CURL_IMP_VERSION).$(CURL_IMP_ASSET_TARGET).tar.gz
CURL_IMP_RELEASE_URL := https://github.com/unstableneutron/curl-impersonate/releases/download/$(CURL_IMP_VERSION)/$(CURL_IMP_LIB_ASSET)

## Install curl-impersonate, downloading the pinned release asset if available
install-curl-impersonate:
	@if [ -f "$(CURL_IMP)/lib/libcurl-impersonate.a" ]; then \
		printf "\033[33mcurl-impersonate already installed at $(CURL_IMP)\033[0m\n"; \
	else \
		$(MAKE) download-curl-impersonate || $(MAKE) build-curl-impersonate; \
	fi

## Download prebuilt curl-impersonate release artifacts
download-curl-impersonate: clean-curl-impersonate
	@if [ -z "$(CURL_IMP_ASSET_TARGET)" ]; then \
		printf "\033[33mNo curl-impersonate release asset mapping for $(OS)-$(ARCH)\033[0m\n"; \
		exit 1; \
	fi
	@printf "\033[36mDownloading curl-impersonate $(CURL_IMP_VERSION) $(CURL_IMP_ASSET_TARGET)...\033[0m\n"
	@tmp=$$(mktemp -d); \
	trap 'rm -rf "$$tmp"' EXIT INT TERM; \
	curl --fail -L --retry 5 --retry-all-errors --retry-delay 2 -o "$$tmp/$(CURL_IMP_LIB_ASSET)" "$(CURL_IMP_RELEASE_URL)"; \
	mkdir -p "$$tmp/extract" "$(CURL_IMP)/include" "$(CURL_IMP)/lib"; \
	tar -xzf "$$tmp/$(CURL_IMP_LIB_ASSET)" -C "$$tmp/extract"; \
	cp -R "$$tmp/extract/include/." "$(CURL_IMP)/include/"; \
	cp "$$tmp/extract"/libcurl-impersonate* "$(CURL_IMP)/lib/"; \
	test -f "$(CURL_IMP)/include/curl/curl.h"; \
	test -f "$(CURL_IMP)/lib/libcurl-impersonate.a"
	@printf "\033[33mDone curl-impersonate $(OS)-$(ARCH)\033[0m\n"

## Build curl-impersonate from source (requires cmake, ninja, patch, and clang)
build-curl-impersonate: clean-curl-impersonate
	@printf "\033[36mBuilding curl-impersonate $(OS)-$(ARCH) from vendor/curl-impersonate...\033[0m\n"
	@mkdir -p $(CURL_IMP)
ifeq ($(OS), linux)
	@$(MAKE) -C vendor/curl-impersonate prepare-libidn2 BUILD_DIR=$(CURL_IMP_BUILD)
endif
	@$(MAKE) -C vendor/curl-impersonate install BUILD_DIR=$(CURL_IMP_BUILD) CMAKE_CONFIGURE_ARGS='$(CURL_IMP_CMAKE_ARGS)'
	@cp $(CURL_IMP_BUILD)/deps/install/lib/*.a $(CURL_IMP)/lib/
	@if [ -d "$(CURL_IMP_BUILD)/deps/install/include/openssl" ]; then \
		cp -R $(CURL_IMP_BUILD)/deps/install/include/openssl $(CURL_IMP)/include/; \
	fi
	@printf "\033[33mDone curl-impersonate $(OS)-$(ARCH)\033[0m\n"

clean-curl-impersonate:
	@printf "\033[36mCleaning curl-impersonate build...\033[0m\n"
	@rm -Rf $(CURL_IMP_BUILD) $(CURL_IMP)

data:
	cd src/data && go run public_suffix_list_gen.go > public_suffix_list.zig
