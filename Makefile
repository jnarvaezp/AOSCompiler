SHELL := /bin/bash
NAME := aoscompiler
VERSION := $(shell grep "Version" share/desktop/$(NAME).desktop |cut -d"=" -f2)
TYPE := $(shell dpkg-architecture |grep "DEB_BUILD_ARCH=" |cut -d"=" -f2)

help:
	@echo "Help: $(NAME): $(VERSION)-$(TYPE)"
	@echo "Usage: make [package|install|clean] or all"

all: package install clean

package:
	@echo "Building $(NAME): $(VERSION)-$(TYPE)"
	-dpkg-buildpackage -rfakeroot

install:
	@echo "Installing $(NAME): $(VERSION)-$(TYPE)"
	-sudo dpkg -i ../${NAME}_${VERSION}_${TYPE}.deb

clean:
	@echo "Cleaning up $(NAME): $(VERSION)-$(TYPE)"
	-rm -rf debian/$(NAME)
	-rm -rf debian/$(NAME).substvars
	-rm -rf debian/*.log
	-rm -rf debian/files
	-rm -rf debian/*debhelper
	-rm -rf ../$(NAME)_*
