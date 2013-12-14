define (require, exports, module) ->
  LDFW = require "ldfw"
  PhysicsObject = require "physics-object"

  class Mob extends PhysicsObject
    minPackageInteractionDelay: 500
    constructor: ->
      super

      {@package} = @game
      @lastPackageInteraction = Date.now()

    canInteractWithPackage: ->
      return Date.now() - @lastPackageInteraction > @minPackageInteractionDelay

  module.exports = Mob
