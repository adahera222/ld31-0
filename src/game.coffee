define (require, exports, module) ->
  Player = require "player"
  Level = require "level"
  Package = require "package"

  class Game
    constructor: (@app) ->
      @level = new Level @app, this
      @package = new Package @app, this
      @player = new Player @app, this

      @package.attachTo @player

      @mobs = []

    update: (delta) ->
      @player.update delta
      @package.update delta

  module.exports = Game
