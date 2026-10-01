# Always keep work dir as same as Makefile's 
# Even with ONESHELL, shell commands don't persist across different targets,
# nor is it like passing commands into make variables to run persists in targets

.ONESHELL:
SHELL := $(shell command -v bash)
.SHELLFLAGS := -euo pipefail -c  
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
.SILENT:


# Add orderly for reliability
.PHONY: all build rebuild build-amd64 build-arm64 clean getbin binrm x

# clean all including bin, get it new, and build
all: clean getbin x build


build:
	./build.sh
	
	
# clean and build with prefound bin
rebuild: clean x build

# clean and create new dirs
clean: 
	rm -rf dist
	mkdir dist
	rm -rf build
	mkdir build
	rm -rf x
	mkdir -p x/{amd64,arm64}/{meta,payload}

# Get latest rpm binaries amd64 and arm64 of brave-origin		
getbin: binrm
	VER=$$(curl -fsSL 'https://versions.brave.com/latest/release-linux-x64.version'); \
	curl -fsSLo bin/amd64.rpm "https://brave-browser-rpm-release.s3.brave.com/x86_64/brave-origin-$${VER}-1.x86_64.rpm"
	
	
	VER="$$(curl -fsSL 'https://versions.brave.com/latest/release-linux-arm64.version')"; \
	curl -fsSLo bin/arm64.rpm "https://brave-browser-rpm-release.s3.brave.com/aarch64/brave-origin-$${VER}-1.aarch64.rpm"
# Remove binary. Just mentioning name's enough as it's in work dir root
binrm:
	rm -rf bin
	mkdir bin
	
# Extract metadata and payloads of amd64 and arm64	
x: clean
	rpm -qpi bin/amd64.rpm            > x/amd64/meta/info.txt 	 2>/dev/null
	rpm -qpR bin/amd64.rpm 	  	  > x/amd64/meta/dep.txt  	 2>/dev/null
	rpm -qpl bin/amd64.rpm            > x/amd64/meta/filelist.txt	 2>/dev/null
	rpm -qp --scripts bin/amd64.rpm   > x/amd64/meta/scripts.txt	 2>/dev/null
	

	rpm -qpi bin/arm64.rpm            > x/arm64/meta/info.txt  	  2>/dev/null
	rpm -qpR bin/arm64.rpm            > x/arm64/meta/dep.txt 	  2>/dev/null
	rpm -qpl bin/arm64.rpm            > x/arm64/meta/filelist.txt 	  2>/dev/null
	rpm -qp --scripts bin/arm64.rpm   > x/arm64/meta/scripts.txt  	  2>/dev/null
	

	rpm2cpio bin/amd64.rpm 	| cpio -idm -D x/amd64/payload   2>/dev/null
	rpm2cpio bin/arm64.rpm	| cpio -idm -D x/arm64/payload 2>/dev/null
	
pkg:
	 rm -rf dist
	 mkdir dist
	 nfpm package -p rpm -f amd64.yaml -t dist/
	 nfpm package -p rpm -f arm64.yaml -t dist/

