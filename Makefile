default: install

install: build publish

build:
	cabal-dev install

publish:
	cp cabal-dev/bin/sclent bin/sclent