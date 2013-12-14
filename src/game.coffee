define (require, exports, module) ->
  Player = require "player"
  Level = require "level"
  Package = require "package"

  class Game
    horizontalScrollPadding: 0.2
    verticalScrollPadding: 0.3
    constructor: (@app) ->
      @level = new Level @app, this
      @package = new Package @app, this
      @player = new Player @app, this
      @player.position.set @app.getWidth() / 2, @app.getHeight() - @level.floorHeight

      @package.attachTo @player

      @mobs = []

    update: (delta) ->
      @level.update delta
      @player.update delta
      @package.update delta

  module.exports = Game
