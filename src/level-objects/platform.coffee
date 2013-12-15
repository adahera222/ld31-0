define (require, exports, module) ->
  LDFW = require "ldfw"

  class Platform
    constructor: (@app, @game, @level, options) ->
      {@width, @position} = options

    getRealPosition: ->
      realPosition = @position
        .clone()
        .multiply @level.constructor.GRID_SIZE # Level.GRID_SIZE didnt work...

      realPosition.y = @app.getHeight() - realPosition.y
      return realPosition

  module.exports = Platform
