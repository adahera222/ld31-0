define (require, exports, module) ->
  LDFW = require "ldfw"

  class Platform
    constructor: (@app, @game, options) ->
      {@width, @position} = options

  module.exports = Platform
