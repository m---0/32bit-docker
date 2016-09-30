#!/usr/bin/make
# USAGE: 'sudo make' to build a docker image from scratch (massimos/debian:jessie).
# Define variables on the make command line to change behaviour
# e.g.
#       sudo make distro=debian release=wheezy arch=i386 tag=latest
#       sudo make distro=centos release=6.8 arch=i386 tag=latest

# variables that can be overridden:
distro  ?= debian
release ?= jessie
prefix  ?= massimos
arch    ?= i386
mirror  ?= http://httpredir.debian.org/debian/
tag     ?= $(distro)-$(release)-$(arch)
image   = $(prefix)/$(distro)-$(arch):$(tag)

# available distros
debian = debian-$(release)-$(arch)
centos = centos-$(release)-$(arch)
centos_pkg = centos-release-$(subst .,-,$(release)).el6.centos.12.3.i686.rpm
centos_mirror = http://mirror.centos.org/centos/6/os/$(arch)/Packages/$(centos_pkg)
centos_rootfs = $(shell pwd)/rootfs/$(tag)

build: $(tag)/root.tar $(tag)/Dockerfile
	docker build -t $(image) $(tag)

rev=$(shell git rev-parse --verify HEAD)
$(debian)/Dockerfile: Dockerfile.debian $(tag)
	sed 's/SUBSTITUTION_FAILED/$(rev)/' $< >$@
$(centos)/Dockerfile: Dockerfile.centos $(tag)
	sed 's/SUBSTITUTION_FAILED/$(rev)/' $< >$@

$(tag):
	mkdir $@

$(tag)/root.tar: rootfs/$(tag)/etc $(tag)
	cd rootfs/$(tag) \
		&& tar -c --numeric-owner -f ../../$(tag)/root.tar ./

rootfs/$(tag):
	mkdir -p $@

rootfs/$(debian)/etc: rootfs/$(tag)
	debootstrap --arch $(arch) $(release) $< $(mirror) \
		&& chroot $< apt-get clean

rootfs/$(centos)/etc: rootfs/$(tag)
#	wget $(centos_mirror) -O rootfs/$(tag)/$(centos_pkg)
	rpm --root $(centos_rootfs) --rebuilddb
	rpm --root $(centos_rootfs) -i $</$(centos_pkg) 
	yum --nogpgcheck --installroot=$(centos_rootfs) groupinstall core -y
	yum --installroot=$(centos_rootfs) list installed | awk '/firmware/{system("yum remove --installroot=$(centos_rootfs) " $1 " -y")}'
	sed -e 's/$releaserver/6/g' -i $</etc/yum.repos.d/CentOS-Base.repo

clean:
	rm -f $(strip tag)/root.tar $(tag)/Dockerfile
	rm -rf rootfs/$(tag)
	rm -rf $(tag)

.PHONY: clean build
