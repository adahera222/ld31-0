define (require, exports, module) ->
  LDFW = require "ldfw"

  class Player
    constructor: (@game) ->
      @position = new LDFW.Vector2(0, 0)

    getPosition: -> @position
    setPosition: -> @position.set.apply @position, arguments

  module.exports = Player
