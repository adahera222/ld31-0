define (require, exports, module) ->
  LDFW = require "ldfw"
  Platform = require "level/platform"

  class Level
    constructor: (@app, @game) ->
      @gravity = new LDFW.Vector2 0, 5000
      @platforms = []

      @platforms.push new Platform @app, @game, {
        position: new LDFW.Vector2(5, 4)
        width: 8
      }

    update: (delta) ->
      return

  module.exports = Level
