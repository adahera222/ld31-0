define (require, exports, module) ->
  LDFW = require "ldfw"
  PhysicsObject = require "physics-object"

  class Mob extends PhysicsObject
    constructor: ->
      super

      {@package} = @game

  module.exports = PhysicsObject
