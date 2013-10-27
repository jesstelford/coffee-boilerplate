# Coffee Boilerplate

A quickstart [CoffeeScriptRedux](https://github.com/michaelficarra/CoffeeScriptRedux) / [CommonJS](http://www.commonjs.org/) webpage project, powered by [npm](https://npmjs.org/), and packaged with [commonjs-everywhere](https://github.com/michaelficarra/commonjs-everywhere).

## Quickstart

Install [nodejs](http://nodejs.org/download/).

Set project-appropriate values in the `package.json` file:

 * `name`
 * `description`
 * `homepage`
 * `author`
 * `repository`
 * `bugs`
 * `licenses`

Run the following commands

```bash
$ npm install # Install all the npm dependancies
$ make bundle # Build the project
```

Open `dist/index.html` in your favourite browser

## Project Structure

```bash
├── dist
│   ├── index.html   # The main entry point to your web page
│   └── bundle.js    # The bundled coffeescript source
├── Makefile         # This Makefile defines the build (and other) tasks
├── package.json     # Your project's description
├── src              # All your source will live here
│   └── index.coffee # The main CommonJs module, exported to the global namespace as App
├── test             # Place your mocha test files here
└── vendor           # Place your non-npm modules here
```

## Build info

Available commands are contained in `Makefile`:

 * `$ make` / `$ make build`: Compile `src/*.coffee` to `lib/*.js`
 * `$ make bundle`: Build `dist/bundle.js` from `lib/*.js` (calls `$ make build` for you)
 * `$ make dev`: Same as `$ make bundle`, but includes a sourcemap for the minifed js (no map to coffeescript yet)
 * `$ make test`: Run the `test/.coffee` tests through Mocha
 * `$ make clean`: Clean up the built files (`lib/*.js` and `dist/bundle.js`)

## Example

**`dist/index.html`:**

```html
<!DOCTYPE html>
<html>
  <body>
    <script src="bundle.js"></script>
    <script>
      App.doIt();
    </script>
  </body>
</html>
```

**`src/index.coffee`:**

```coffeescript
Dog = require('dog')
exports.doIt = ->
  doug = new Dog
  doug.sayIt()
```

**`src/dog.coffee`:**

```coffeescript
Animal = require('animal')
module.exports = class Dog extends Animal
  whatISay: "woof!"
```

**`src/animal.coffee`:**

```coffeescript
module.exports = class Animal
  sayIt: ->
    alert @whatISay
```
