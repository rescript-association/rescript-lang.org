SHELL = /bin/bash

node_modules/.bin/rescript:
	npm install
	npm run update-index

build: node_modules/.bin/rescript	
	node_modules/.bin/rescript
	npm run update-index

dev: build
	npm run dev

test: build
	npm run test

clean:
	rm -r node_modules lib

.DEFAULT_GOAL := build

.PHONY: clean test
