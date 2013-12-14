define (require, exports, module) ->
  Player = require "player"
  Level = require "level"

  class Game
    constructor: (@app) ->
      @level = new Level @app, this
      @player = new Player @app, this

    update: (delta) ->
      @player.update delta

  module.exports = Game
