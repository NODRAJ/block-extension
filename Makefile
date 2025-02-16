include .make/Makefile.inc
#include packages/background/Makefile
#include packages/ui/Makefile
BRANCH					:= $(shell git symbolic-ref --short -q HEAD | sed 's/[\.\/]/-/g')
MODULES_DIR 			:= packages
MODULES					:= $(shell ls $(MODULES_DIR))
INLINE_RUNTIME_CHUNK	:= false
GENERATE_SOURCEMAP		:= false
TS_NODE_PROJECT			:= tsconfig.json


depcheck:
	@cd packages/background && npx depcheck
	@cd packages/ui && npx depcheck

test/background:
	@cd packages/background && $(MAKE) test/background

test/ui:
	@cd packages/ui && $(MAKE) test/ui

test:
	$(MAKE) test/background
	$(MAKE) test/ui


install:
	@cd packages/background && rm -rf node_modules
	@cd packages/ui && rm -rf node_modules
	@cd packages/provider && rm -rf node_modules
	@cd packages/background && yarn install
	@cd packages/ui && yarn install
	@cd packages/provider && yarn install


cp/snarks:
	@mkdir -p dist/snarks/tornado
	@cp utils/tornado/* dist/snarks/tornado

build/ui:
	@cd packages/ui && $(MAKE) build/ui --no-print-directory

build/background:
	@cd packages/background && $(MAKE) build/background --no-print-directory

build/provider:
	@cd packages/provider && $(MAKE) build/provider --no-print-directory

build:
	@$(MAKE) build/background --no-print-directory
	@$(MAKE) build/provider --no-print-directory
	@$(MAKE) build/ui --no-print-directory
	@$(MAKE) cp/snarks --no-print-directory
