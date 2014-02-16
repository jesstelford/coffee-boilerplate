default: run-dev

BROWSER_SRCDIR = src/browser
BROWSER_DISTDIR = public/js
BROWSER_MAIN_MODULE = App

BACKEND_SRCDIR = src/backend
BACKEND_LIBDIR = lib

BINDIR = node_modules/.bin

TESTDIR = test

BACKEND_SRC = $(shell find "$(BACKEND_SRCDIR)" -name "*.coffee" -type f | sort)
BACKEND_LIB = $(BACKEND_SRC:$(BACKEND_SRCDIR)/%.coffee=$(BACKEND_LIBDIR)/%.js)

TEST = $(shell find "$(TESTDIR)" -name "*.coffee" -type f | sort)
CJSIFYEXTRAPARAMS =

COFFEE=$(BINDIR)/coffee --js
MOCHA=$(BINDIR)/mocha --compilers coffee:coffee-script-redux/register -r coffee-script-redux/register -r test-setup.coffee -u tdd -R dot
CJSIFY=$(BINDIR)/cjsify --minify --root "$(BROWSER_SRCDIR)"

all: backend browser test

backend: $(BACKEND_LIB)

backend-dev: backend

browser:
	@mkdir -p "$(BROWSER_DISTDIR)"
	@rm -f "$(BROWSER_DISTDIR)/$(BROWSER_MAIN_MODULE).js.map"
	$(CJSIFY) --export $(BROWSER_MAIN_MODULE) $(CJSIFYEXTRAPARAMS) "$(BROWSER_MAIN_MODULE).coffee" >"$(BROWSER_DISTDIR)/$(BROWSER_MAIN_MODULE).js"

browser-dev: browser-dev-dep browser
	@mv "$(BROWSER_MAIN_MODULE).js.map" "$(BROWSER_DISTDIR)/"

run-dev: browser-dev backend-dev node-dev

run: browser backend node-stage

node-dev:
	NODE_ENV=development node "$(BACKEND_LIBDIR)/$(shell node -pe 'require("./package.json").main')"

node-stage:
	NODE_ENV=staging node "$(BACKEND_LIBDIR)/$(shell node -pe 'require("./package.json").main')"

$(BACKEND_LIBDIR)/%.js: $(BACKEND_SRCDIR)/%.coffee
	@mkdir -p "$(@D)"
	$(COFFEE) --input "$<" >"$@"

browser-dev-dep:
	$(eval CJSIFYEXTRAPARAMS := --source-map "$(BROWSER_MAIN_MODULE).js.map" --inline-sources)

.PHONY: phony-dep release test loc clean dep-dev run-dev run node browser
phony-dep:

VERSION = $(shell node -pe 'require("./package.json").version')
release-patch: NEXT_VERSION = $(shell node -pe 'require("semver").inc("$(VERSION)", "patch")')
release-minor: NEXT_VERSION = $(shell node -pe 'require("semver").inc("$(VERSION)", "minor")')
release-major: NEXT_VERSION = $(shell node -pe 'require("semver").inc("$(VERSION)", "major")')
release-patch: release
release-minor: release
release-major: release

release: all
	@printf "Current version is $(VERSION). This will publish version $(NEXT_VERSION). Press [enter] to continue." >&2
	@read nothing
	node -e "\
		var j = require('./package.json');\
		j.version = '$(NEXT_VERSION)';\
		var s = JSON.stringify(j, null, 2) + '\n';\
		require('fs').writeFileSync('./package.json', s);"
	git commit package.json -m 'Version $(NEXT_VERSION)'
	git tag -a "v$(NEXT_VERSION)" -m "Version $(NEXT_VERSION)"
	git push --tags origin HEAD:master

test:
	$(MOCHA) $(TEST)
$(TESTDIR)/%.coffee: phony-dep
	$(MOCHA) "$@"

loc:
	@wc -l "$(BROWSER_SRCDIR)"/* "$(BACKEND_SRCDIR)"/*

clean:
	@rm -rf "$(BACKEND_LIBDIR)" "$(BROWSER_DISTDIR)/$(BROWSER_MAIN_MODULE).js" "$(BROWSER_DISTDIR)/*.map"
