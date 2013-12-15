requirejs.config
  paths:
    jquery: "../lib/jquery/jquery"
    ldfw: "../ldfw"
    eventemitter: "../lib/eventEmitter/eventEmitter"
    async: "../lib/async/lib/async"
    underscore: "../lib/underscore/underscore"
  shim:
    underscore:
      exports: "_"

define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  $ = require "jquery"
  Game = require "./app"

  window.debug = ->
    text = arguments[0]
    if arguments.length > 1
      text = Array.prototype.slice.call(arguments).join " "

    $("#debug").text text

  $ ->
    window.game = new Game $("#game")
