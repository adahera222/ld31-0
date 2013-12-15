define (require, exports, module) ->
  LDFW = require "ldfw"
  PhysicsObject = require "physics-object"

  class Mob extends PhysicsObject
    stunDuration: 2000
    minDelayAfterPackageDrop: 300
    constructor: ->
      super

      {@package} = @game
      @speed = new LDFW.Vector2 500, 500

      @stunned = false
      @stunStart = null

      @lastPunch = Date.now()

      @packageDroppedAt = Date.now()

    lostPackage: ->
      @stunned = true
      @stunStart = Date.now()

    update: ->
      super

      if @stunned and
        Date.now() - @stunStart > @stunDuration
          @stunned = false

    canPickPackage: ->
      Date.now() - @packageDroppedAt > @minDelayAfterPackageDrop

    droppedPackage: ->
      @packageDroppedAt = Date.now()

    pickedPackage: -> return

    _jump: ->
      if @onGround and not @onLadder
        @velocity.y = -@jumpForce

  module.exports = Mob
