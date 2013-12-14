define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  GameScreen = require "./screens/game-screen"

  ###
   * App definition
  ###
  class App extends LDFW.Game
    constructor: ->
      super

      @screen = new GameScreen this

    draw: (context) ->
      super

      @screen.draw context

  ###
   * Expose App
  ###
  module.exports = App
