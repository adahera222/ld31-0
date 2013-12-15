define (require, exports, module) ->
  LDFW = require "ldfw"
  PhysicsObject = require "physics-object"

  class Mob extends PhysicsObject
    minPackageInteractionDelay: 300
    stunDuration: 2000
    constructor: ->
      super

      {@package} = @game
      @speed = new LDFW.Vector2 500, 500
      @lastPackageInteraction = Date.now()

      @stunned = false
      @stunStart = null

    lostPackage: ->
      @stunned = true
      @stunStart = Date.now()

    update: ->
      super

      if @stunned and
        Date.now() - @stunStart > @stunDuration
          @stunned = false

    canInteractWithPackage: ->
      return Date.now() - @lastPackageInteraction > @minPackageInteractionDelay

    _jump: ->
      if @onGround and not @onLadder
        @velocity.y = -@jumpForce

  module.exports = Mob
