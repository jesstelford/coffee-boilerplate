# Coffee Boilerplate

A quickstart CoffeeScript node server, designed to serve compiled, minified, and source-mapped CoffeeScript modules to the browser. 

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
├── lib                  # Where the compiled backend coffeescript source is placed after `make X`
├── Makefile             # This Makefile defines the build (and other) tasks (see below for more)
├── package.json         # Your project's description
├── public
│   ├── index.html       # The main entry point to your web page
│   └── js               # Where the bundled coffeescript source is placed after `make X`
├── src                  # All your source will live here
│   ├── backend          # Where all your backend CoffeeScript lives
│   │   └── index.coffee # The basic node server (powered by express)
│   └── browser          # Where all your browser CoffeeScript lives
│       └── App.coffee   # The main CommonJs module, exported to the global namespace
├── test                 # Place your mocha test files here
└── vendor               # Place your non-npm modules here
```

See the `Makefile` to change some of the directories

## Build info

Available commands are contained in `Makefile`:

 * `$ make run-dev` / `$ make`: Same as `$ make browser-dev && make backend-dev && make node-dev`
 * `$ make run`: Same as `$ make browser && make backend && make node-stage`
 * `$ make node-dev`: Boot up the node server in development mode (does **not** recompile any code)
 * `$ make node-stage`: Boot up the node server in staging mode (does **not** recompile any code)
 * `$ make browser-dev`: Compile, minify, and source-map browser CoffeeScript 
 * `$ make browser`: Compile and minify browser CoffeeScript 
 * `$ make backend-dev`: Compile backend CoffeeScript 
 * `$ make backend`: Compile backend CoffeeScript 
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

**`public/index.html`:**

```html
<!DOCTYPE html>
<html>
  <body>
    <script src="App.js"></script>
    <script>
      App.doIt();
    </script>
  </body>
</html>
```

**`src/browser/App.coffee`:** (where `BROWSER_MAIN_MODULE = App` in `Makefile`)

```coffeescript
Dog = require('dog')
exports.doIt = ->
  doug = new Dog
  doug.sayIt()
```

**`src/browser/dog.coffee`:**

```coffeescript
Animal = require('animal')
module.exports = class Dog extends Animal
  whatISay: "woof!"
```

**`src/browser/animal.coffee`:**

```coffeescript
module.exports = class Animal
  sayIt: ->
    console.log @whatISay
```

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
 * [CommonJS](http://www.commonjs.org/)
 * [express](http://expressjs.com/)
 * [commonjs-everywhere](https://github.com/michaelficarra/commonjs-everywhere)
 * [npm](https://npmjs.org/)
 * [node.js](http://nodejs.org/)
