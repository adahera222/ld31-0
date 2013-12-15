define (require, exports, module) ->
  LDFW = require "ldfw"

  class Platform
    constructor: (@app, @game, options) ->
      {@level} = @game
      {@width, @position} = options

    getRealPosition: ->
      @position
        .clone()
        .multiply @level.GRID_SIZE

  module.exports = Platform
