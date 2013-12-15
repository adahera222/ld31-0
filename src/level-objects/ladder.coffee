define (require, exports, module) ->
  LDFW = require "ldfw"

  class Ladder
    constructor: (@app, @game, @level, options) ->
      {@height, @position} = options

    getRealPosition: ->
      realPosition = @position
        .clone()
        .multiply @level.constructor.GRID_SIZE # Level.GRID_SIZE didnt work...

      realPosition.y = @app.getHeight() - realPosition.y
      return realPosition

  module.exports = Ladder
