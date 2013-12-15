define (require, exports, module) ->
  LDFW = require "ldfw"
  PhysicsObject = require "physics-object"

  class Mob extends PhysicsObject
    stunDuration: 2000
    constructor: ->
      super

      {@package} = @game
      @speed = new LDFW.Vector2 500, 500

      @stunned = false
      @stunStart = null

      @lastPunch = Date.now()

      @packageDroppedAt = Date.now()

      @health = 3

    lostPackage: ->
      @stunned = true
      @stunStart = Date.now()

    update: ->
      super

      if @stunned and
        Date.now() - @stunStart > @stunDuration
          @stunned = false

    canPickPackage: ->
      @package.previousMob isnt this

    droppedPackage: ->
      @packageDroppedAt = Date.now()

    pickedPackage: -> return

    hurt: (direction) ->
      @health--
      @knockback.set 10, 5
      @knockbackXDirection = direction

    _jump: ->
      if @onGround and not @onLadder
        @velocity.y = -@jumpForce

  module.exports = Mob
