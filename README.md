LDFW CoffeeScript Example
=========================

This is a very simple game using the [LDFW](https://github.com/saschagehlich/ldfw)
gaming framework. It tries to make use of all the components that LDFW provides

## Installation

Since the build system is based on [Node.js](http://nodejs.org/), make sure you
have it installed. Then:

* Install [TexturePacker](http://www.texturepacker.com) with the command line extension
in case you want to automatically build the spritesheets from the `assets` folder.
* Run `npm install -g bower` to install [Bower](https://github.com/bower/bower),
the dependency manager we are using.
* Run `npm install` to install [Grunt](https://github.com/gruntjs/grunt), the
task runner our build system is based on, as well as all the grunt extensions for
build CoffeeScript files etc.
* Run `bower install` to install all frontend dependencies
* Finally, run `grunt` to build the game and start the webserver
* Point your browser to (http://localhost:8080)

## Development

The CoffeeScript source code lives in `src/` and will be compiled into the `build/`
directory. `Grunt` automatically watches for file changes in both the `src` directory
and the `assets` directory and will re-compile changed files and build new sprite
sheets as soon as you changed some assets.

## License

MIT

