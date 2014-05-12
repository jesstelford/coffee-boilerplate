# Coffee Boilerplate

A quickstart CoffeeScript node server, designed to serve compiled, minified, and source-mapped CoffeeScript modules to the browser, templated with Handlebars. 

## Quickstart

Install [nodejs](http://nodejs.org/download/).

Run the following commands

```bash
$ git clone https://github.com/jesstelford/coffee-boilerplate.git && cd coffee-boilerplace
$ npm install # Install all the npm dependancies
$ make        # Build the project, and fire up a minimal server
```

Open `http://localhost:3000` in your favourite browser

(*note*: This boilerplate codebase contains no executable code, so you wont see
anything when you launch that page)

## Project Structure

```bash
├── lib                # Where the compiled backend coffeescript source is placed after `make X`
├── Makefile           # This Makefile defines the build (and other) tasks (see below for more)
├── package.json       # Your project's description
├── public             # Publically accessible directory
│   ├── js             # Where the bundled coffeescript source is placed after `make X`
│   └── vendor         # Place 3rd party assets here so it wont be erased upon compile
├── src                # All your source will live here
└── test               # Place your mocha test files here
```

The `src` directory is structured like so:
```bash
├── backend            # Where all your backend code lives
│   ├── templates
│   │   └── index.hbs  # The Handlebars template served up by the node server
│   └── index.coffee   # The basic node server (powered by express)
└── browser            # Where all your browser code lives
    ├── templates
    │   └── test.hbs   # An example Handlebars template rendered browser-side
    ├── vendor         # CommonJS modules to be included in the browser bundle
    └── module         # A directory of modules, each compiled down to a single .js file
```

The `module` directory is structured like so:
```bash
└── App                # The module's directory is also the name exported into global namespace
    └── index.coffee   # The main CommonJs module, the entry point for this module
└── SomeModule
    └── index.coffee
└── AnotherModule
    └── index.coffee
```

See the `Makefile` to change some of the directories

## Build info

Available commands are contained in `Makefile`:

 * `$ make run-dev` / `$ make`: Same as `$ make browser-dev && make backend-dev && make node-dev`
 * `$ make run`: Same as `$ make browser && make backend && make node-stage`
 * `$ make node-dev`: Boot up the node server in development mode (does **not** recompile any code)
 * `$ make node-stage`: Boot up the node server in staging mode (does **not** recompile any code)
 * `$ make browser-dev`: Compile, minify, and source-map browser CoffeeScript & Handlebars
 * `$ make browser`: Compile and minify browser CoffeeScript & Handlebars
 * `$ make backend-dev`: Compile backend CoffeeScript & Handlebars
 * `$ make backend`: Compile backend CoffeeScript & Handlebars
 * `$ make test`: Run the `test/.coffee` tests through Mocha
 * `$ make clean`: Clean up the built files and source maps
 * `$ make loc`: Show the LOC (lines of code) count
 * `$ make all`: Same as `$ make backend && make browser && make test`
 * `$ make release-[patch|minor|major]`: Update `package.json` version, create a git tag, then push to `origin`

### Module Exported to the Browser

The `Makefile` defines a variable `BROWSER_MAIN_MODULE` (default: `App`) which influences a number of factors:

 1. This must match the filename (without the `.coffee` extension) of the file within `src/browser` that contains the module to export
 1. This will be used to name the compiled and minified `.js` file dropped into `public/js`
 1. This will be used to name the exported object in the browser. For example, if `BROWSER_MAIN_MODULE = App`, then in the module exported to the browser is `window.App`

## Example

See the `/src` directory for a basic example

## Project Settings

Set project-appropriate values in the `package.json` file:

 * `name`
 * `description`
 * `homepage`
 * `author`
 * `repository`
 * `bugs`
 * `licenses`

## Powered By

 * [CoffeeScriptRedux](https://github.com/michaelficarra/CoffeeScriptRedux)
 * [CommonJS](http://www.commonjs.org)
 * [Commonjs-everywhere](https://github.com/michaelficarra/commonjs-everywhere)
 * [Express](http://expressjs.com)
 * [Handlebars](http://handlebarsjs.com)
 * [node.js](http://nodejs.org)
 * [npm](https://npmjs.org)

## Donations

<img src="http://dogecoin.com/imgs/dogecoin-300.png" width=100 height=100 align=right />
Like what I've created? *So do I!* I develop this project in my spare time, free for the community.

If you'd like to say thanks, buy me a beer by **tipping with Dogecoin**: *D7cw4vVBwZRwrZkEw8L7rqt8cX24QCbZxV*
