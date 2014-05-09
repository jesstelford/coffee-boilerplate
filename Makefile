default: run-dev

BROWSER_SRCDIR = src/browser
BROWSER_DISTDIR = public
BROWSER_JSDIR = $(BROWSER_DISTDIR)/js
BROWSER_TMPL_SRCDIR = $(BROWSER_SRCDIR)/templates
BROWSER_TMPL_DISTDIR = tmp/templates
BROWSER_MAIN_MODULE = App

BACKEND_JS_SRCDIR = src/backend
BACKEND_JS_LIBDIR = lib
BACKEND_TMPL_SRCDIR = $(BACKEND_JS_SRCDIR)/templates
BACKEND_TMPL_LIBDIR = $(BACKEND_JS_LIBDIR)/templates

TEMPLATE_EXTENSION = hbs
BINDIR = node_modules/.bin

TESTDIR = test

BACKEND_SRC = $(shell find "$(BACKEND_JS_SRCDIR)" -name "*.coffee" -type f)
BACKEND_LIB = $(BACKEND_SRC:$(BACKEND_JS_SRCDIR)/%.coffee=$(BACKEND_JS_LIBDIR)/%.js)

BACKEND_JSON = $(shell find "$(BACKEND_JS_SRCDIR)" -name "*.json" -type f)
BACKEND_JSON_LIB = $(BACKEND_JSON:$(BACKEND_JS_SRCDIR)/%.json=$(BACKEND_JS_LIBDIR)/%.json)

BACKEND_TMPL_SRC = $(shell find "$(BACKEND_TMPL_SRCDIR)" -name "*.$(TEMPLATE_EXTENSION)" -type f)
BACKEND_TMPL_LIB = $(BACKEND_TMPL_SRC:$(BACKEND_TMPL_SRCDIR)/%.$(TEMPLATE_EXTENSION)=$(BACKEND_TMPL_LIBDIR)/%.js)

BROWSER_TMPL_SRC = $(shell find "$(BROWSER_TMPL_SRCDIR)" -name "*.$(TEMPLATE_EXTENSION)" -type f)
BROWSER_TMPL_DIST = $(BROWSER_TMPL_SRC:$(BROWSER_TMPL_SRCDIR)/%.$(TEMPLATE_EXTENSION)=$(BROWSER_TMPL_DISTDIR)/%.$(TEMPLATE_EXTENSION).js)

# The below sed is essentially:
# sed 's,browser/src/templates/\(.*\).hbs,--alias /templates/\1.hbs:/../../tmp/templates/\1.hbs.js,g'
make_alias = $(shell echo $(file) | sed 's,$(BROWSER_TMPL_SRCDIR)/\(.*\)\.$(TEMPLATE_EXTENSION),--alias /templates/\1.$(TEMPLATE_EXTENSION):/../../$(BROWSER_TMPL_DISTDIR)/\1.$(TEMPLATE_EXTENSION).js,g')
BROWSER_TMPL_ALIASES := $(foreach file,$(BROWSER_TMPL_SRC),$(make_alias))

TEST = $(shell find "$(TESTDIR)" -name "*.coffee" -type f | sort)
CJSIFYEXTRAPARAMS =

COFFEE=$(BINDIR)/coffee --js
MOCHA=$(BINDIR)/mocha --compilers coffee:coffee-script-redux/register -r coffee-script-redux/register -r test-setup.coffee -u tdd -R dot
CJSIFY=$(BINDIR)/cjsify --minify --root "$(BROWSER_SRCDIR)"
HANDLEBARS=$(BINDIR)/handlebars
HANDLEBARS_PARAMS= --extension="$(TEMPLATE_EXTENSION)"

all: backend browser test

backend: $(BACKEND_TMPL_LIB) $(BACKEND_LIB) $(BACKEND_JSON_LIB)

backend-dev: backend

browser: $(BROWSER_TMPL_DIST)
	$(eval CJSIFYEXTRAPARAMS += $(BROWSER_TMPL_ALIASES))
	@mkdir -p "$(BROWSER_JSDIR)"
	@rm -f "$(BROWSER_JSDIR)/$(BROWSER_MAIN_MODULE).js.map"
	$(CJSIFY) --export $(BROWSER_MAIN_MODULE) $(CJSIFYEXTRAPARAMS) "$(BROWSER_MAIN_MODULE).coffee" >"$(BROWSER_JSDIR)/$(BROWSER_MAIN_MODULE).js"
# Cleanup temporarily compiled handlebars files
	@rm -f $(BROWSER_TMPL_DISTDIR)/*.$(TEMPLATE_EXTENSION).js

browser-dev: browser-dev-dep browser
	@mv "$(BROWSER_MAIN_MODULE).js.map" "$(BROWSER_JSDIR)/"

run-dev: browser-dev backend-dev node-dev

run: browser backend node-stage

node-dev:
	NODE_ENV=development node "$(BACKEND_JS_LIBDIR)/$(shell node -pe 'require("./package.json").main')"

node-stage:
	NODE_ENV=staging node "$(BACKEND_JS_LIBDIR)/$(shell node -pe 'require("./package.json").main')"

$(BACKEND_JS_LIBDIR)/%.js: $(BACKEND_JS_SRCDIR)/%.coffee
	@mkdir -p "$(@D)"
	$(COFFEE) --input "$<" >"$@"

$(BACKEND_TMPL_LIBDIR)/%.js: $(BACKEND_TMPL_SRCDIR)/%.$(TEMPLATE_EXTENSION)
	@mkdir -p "$(@D)"
	$(HANDLEBARS) "$<" --commonjs="handlebars" $(HANDLEBARS_PARAMS) --root="$(BACKEND_TMPL_SRCDIR)" --output "$@"

$(BACKEND_JS_LIBDIR)/%.json: $(BACKEND_JS_SRCDIR)/%.json
	@mkdir -p "$(@D)"
	@cp "$<" "$@"

$(BROWSER_TMPL_DISTDIR)/%.$(TEMPLATE_EXTENSION).js: $(BROWSER_TMPL_SRCDIR)/%.$(TEMPLATE_EXTENSION)
	@mkdir -p "$(@D)"
	$(HANDLEBARS) "$<" --commonjs="./vendor/handlebars" $(HANDLEBARS_PARAMS) --root="$(BROWSER_TMPL_SRCDIR)" --output "$@"

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
	@wc -l "$(BROWSER_SRCDIR)"/* "$(BACKEND_JS_SRCDIR)"/*

clean:
	@rm -rf "$(BACKEND_JS_LIBDIR)" "$(BROWSER_JSDIR)/$(BROWSER_MAIN_MODULE).js" "$(BROWSER_JSDIR)/*.map" "$(BROWSER_TMPL_DISTDIR)"
