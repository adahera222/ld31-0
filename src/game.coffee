define (require, exports, module) ->
  Player = require "player"
  Level = require "level"
  Package = require "package"

  class Game
    scrollPadding: 0.2
    constructor: (@app) ->
      @level = new Level @app, this
      @package = new Package @app, this
      @player = new Player @app, this
      @player.position.set @app.getWidth() / 2, 0

      @package.attachTo @player

      @mobs = []

    update: (delta) ->
      @level.update delta
      @player.update delta
      @package.update delta

  module.exports = Game
