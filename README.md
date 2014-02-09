# Coffee Boilerplate

A quickstart [CoffeeScriptRedux](https://github.com/michaelficarra/CoffeeScriptRedux) / [CommonJS](http://www.commonjs.org/) webpage project, using modules from [npm](https://npmjs.org/), powered by [express](http://expressjs.com/), and packaged with [commonjs-everywhere](https://github.com/michaelficarra/commonjs-everywhere).

## Quickstart

Install [nodejs](http://nodejs.org/download/).

Run the following commands

```bash
$ git clone https://github.com/jesstelford/coffee-boilerplate.git
$ cd coffee-boilerplace
$ npm install     # Install all the npm dependancies
$ make dev-server # Build the project, and fire up a minimal server
```

Open `http://localhost:3000` in your favourite browser

## Project Structure

```bash
├── dist
│   ├── index.html       # The main entry point to your web page
│   └── bundle.js        # The bundled coffeescript source (only exists after `make bundle` et al)
├── main.js              # The basic node server (powered by express)
├── Makefile             # This Makefile defines the build (and other) tasks
├── package.json         # Your project's description
├── src                  # All your source will live here
│   └── frontend         # Where all your frontend CoffeeScript lives
│       └── index.coffee # The main CommonJs module, exported to the global namespace as App
├── test                 # Place your mocha test files here
└── vendor               # Place your non-npm modules here
```

See the `Makefile` to change some of the directories

## Build info

Available commands are contained in `Makefile`:

 * `$ make` / `$ make build`: Compile `src/*.coffee` to `lib/*.js`
 * `$ make bundle`: Build `dist/bundle.js` from `lib/*.js` (calls `$ make build` for you)
 * `$ make dev`: Same as `$ make bundle`, but includes a sourcemap for the minifed js (no map to coffeescript yet)
 * `$ make dev-server`: Start up node with `main.js`, and `NODE_ENV` set to `development`
 * `$ make test`: Run the `test/.coffee` tests through Mocha
 * `$ make clean`: Clean up the built files (`lib/*.js` and `dist/bundle.js`)

## Example

**`dist/index.html`:**

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

**`src/frontend/index.coffee`:**

```coffeescript
Dog = require('dog')
exports.doIt = ->
  doug = new Dog
  doug.sayIt()
```

**`src/frontend/dog.coffee`:**

```coffeescript
Animal = require('animal')
module.exports = class Dog extends Animal
  whatISay: "woof!"
```

**`src/frontend/animal.coffee`:**

```coffeescript
module.exports = class Animal
  sayIt: ->
    alert @whatISay
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
