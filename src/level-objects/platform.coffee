define (require, exports, module) ->
  LDFW = require "ldfw"

  class Platform
    constructor: (@app, @game, @level, options) ->
      {@width, @position} = options

    getRealPosition: ->
      @position
        .clone()
        .multiply @level.constructor.GRID_SIZE # Level.GRID_SIZE didnt work...

  module.exports = Platform
