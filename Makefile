SHELL=/bin/bash
TITLE_START='\033[0;33m+ '
TITLE_END='...\033[0m'

all: test
	@echo -e $(TITLE_START)Done $(TITLE_END)

configure:
	@echo -e $(TITLE_START)Configuring $(TITLE_END)
	cabal-dev configure

build:
	@echo -e $(TITLE_START)Building $(TITLE_END)
	cabal-dev install
	rm -f bin/*
	cp cabal-dev/bin/sclent bin/
	cp cabal-dev/bin/run_tests bin/
	strip bin/*

test: unit

unit: build
	@echo -e $(TITLE_START)Unit tests $(TITLE_END)
	bin/run_tests unit

clean:
	rm -rf dist/

rebuild: clean build
