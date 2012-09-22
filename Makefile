SHELL := /bin/bash
NAME := aoscompiler
VERSION := $(shell grep "Version" share/desktop/$(NAME).desktop |cut -d"=" -f2)
TYPE := $(shell dpkg-architecture |grep "DEB_BUILD_ARCH=" |cut -d"=" -f2)

help:
	@echo "//* $(NAME): $(VERSION)-$(TYPE) *\\"
	@echo "Usage:"
	@echo "debian or [deb-pack|deb-build|deb-clean]"

debian: deb-pack deb-build deb-clean

deb-pack:
ifeq ($(wildcard /etc/debian_version),)
	@echo "Not debian, leaving"
	exit 1
else
	@echo "Building $(NAME): $(VERSION)-$(TYPE)"
	-dpkg-buildpackage -rfakeroot
endif

deb-build:
ifeq ($(wildcard /etc/debian_version),)
	@echo "Not debian, leaving"
	exit 1
else
	@echo "Installing $(NAME): $(VERSION)-$(TYPE)"
	-sudo dpkg -i ../${NAME}_${VERSION}_${TYPE}.deb
endif

deb-clean:
ifeq ($(wildcard /etc/debian_version),)
	@echo "Not debian, leaving"
	exit 1
else
	@echo "Cleaning up $(NAME): $(VERSION)-$(TYPE)"
	-rm -rf debian/$(NAME)
	-rm -rf debian/$(NAME).substvars
	-rm -rf debian/*.log
	-rm -rf debian/files
	-rm -rf debian/*debhelper
	-rm -rf ../$(NAME)_*
endif

