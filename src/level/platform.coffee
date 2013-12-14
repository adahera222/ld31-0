define (require, exports, module) ->
  LDFW = require "ldfw"

  class Platform
    constructor: (@app, @game, options) ->
      {@width, @height, @position} = options


  module.exports = Platform
