VERSION		= $(shell git shortlog | grep -E '^[ ]+\w+' | wc -l)
NEWRELEASE	= $(shell echo $$(($(RELEASE) + 1)))

MESSAGESPOT=po/messages.pot


TOPDIR = $(shell pwd)
DATE="date +%Y%m%d"
PROGRAMNAME=mcollective-restapi
VERSION=$(shell grep "Version:" ./misc/specs/mcollective-restapi.spec)
RELEASE=`expr substr '${VERSION}' 10 5`
TMPDIR=/tmp
BUILDDIR=build

DIST=$(shell rpm --eval "%dist")

all: rpms


manpage:

messages:

bumprelease:	

#setversion: 

build: clean
	@if  [ "$(DIST)" = "%dist" ]; \
	then \
		echo "You must define %dist in your rpmmacros."; \
		exit 1; \
	fi
	@echo 'DIST: $(DIST)'
	@echo '$(RELEASE)'
	@echo '$(TOPDIR)'
	@if test -d .git; then \
		echo Create changelog file; \
		git shortlog > changelog.txt; \
	else \
		echo Not a git repository. Skipping changelog file creation; \
	fi
	mkdir -p ./dist
	#git archive --format=tar --prefix=$(PROGRAMNAME)/ master | gzip > ./dist/$(PROGRAMNAME)-$(RELEASE).tar.gz
	tar czvf ./dist/$(PROGRAMNAME)-$(RELEASE).tar.gz --transform "s,^,/$(PROGRAMNAME)/," *

clean:
	-rm -rf dist/ 
	-rm -rf rpm-build/
	-rm -rf $(TMPDIR)/$(BUILDDIR)

clean_hard:

clean_harder:

clean_hardest: clean_rpms


install: build manpage

install_hard: clean_hard install

install_harder: clean_harder install

install_hardest: clean_harder clean_rpms rpms install_rpm restart

install_rpm:

restart:

recombuild: install_harder restart

clean_rpms:
	-rpm -e mcollective-restapi.spec

sdist: messages

new-rpms: bumprelease rpms

pychecker:

pyflakes:

money: clean

async: install

testit: clean

unittest:

rpms: build manpage sdist
	mkdir -p rpm-build
	cp dist/*.gz rpm-build/
	rpmbuild --define "_topdir %(pwd)/rpm-build" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define '_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm' \
	--define "_specdir %{_topdir}" \
	--define "_sourcedir  %{_topdir}" \
	--define "vendor Think" \
	-ba misc/specs/mcollective-restapi.spec
