#!/usr/bin/env bash
set -euo pipefail


base(){
	rm -rf build/*
	cp -a x/* build/
	cd build
	rm -rf {arm64,amd64}/payload/etc/* # cron.daily rm


	mv amd64/payload/opt/brave.com/brave-origin amd64/payload/opt/orza
	mv arm64/payload/opt/brave.com/brave-origin arm64/payload/opt/orza

	rm -rf {arm64,amd64}/meta
	rm -rf {arm64,amd64}/payload/opt/brave.com
	
	rm -rf {arm64,amd64}/payload/usr
	for arch in arm64 amd64; do
    		cp -r ../src/payload/usr "$arch/payload/usr"
	done
	
	rm -f {arm64,amd64}/payload/opt/orza/brave-origin
	for arch in arm64 amd64; do
    		cp ../src/payload/opt/orza "$arch/payload/opt/orza/orza"
	done
	





}

icon(){

	rm {arm64,amd64}/payload/opt/orza/product_logo_*

	mkdir {arm64,amd64}/payload/opt/orza/icon
	for arch in arm64 amd64; do
    		cp -r ../src/icon/. "$arch/payload/opt/orza/icon/"
	done

}

copyetc(){
	for arch in arm64 amd64; do
  	  cp -r ../src/payload/etc/. $arch/payload/etc/.
	done
}

rmsec(){
	# why a profile just to set unconfined. later: add policy and profile
	rm -rf {arm64,amd64}/payload/opt/orza/apparmor.d
}

base
icon
copyetc
rmsec
