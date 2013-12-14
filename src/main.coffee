requirejs.config
  paths:
    jquery: "../lib/jquery/jquery"
    ldfw: "../ldfw"
    eventemitter: "../lib/eventEmitter/eventEmitter"
    async: "../lib/async/lib/async"

define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  $ = require "jquery"
  Game = require "./app"

  $ ->
    window.game = new Game $("#game")
    game.run()
