define (require, exports, module) ->
  LDFW = require "ldfw"

  class Level
    constructor: (@app, @game) ->
      @gravity = new LDFW.Vector2 0, 5000

    update: (delta) ->
      return

  module.exports = Level
