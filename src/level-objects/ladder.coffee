define (require, exports, module) ->
  LDFW = require "ldfw"

  class Ladder
    constructor: (@app, @game, @level, options) ->
      {@height, @position} = options

  module.exports = Ladder
