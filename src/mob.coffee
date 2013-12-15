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
      @attentionGainedAt = 0
      @followedPlayerOrPackage = false

      @health = 3
      @dead = false

    lostPackage: ->
      @stun()

    stun: ->
      @stunned = true
      @stunStart = Date.now()

    update: ->
      super

      if @stunned and
        Date.now() - @stunStart > @stunDuration
          @stunned = false
          @blinking = false

    canPickPackage: ->
      @package.previousMob isnt this

    droppedPackage: ->
      @packageDroppedAt = Date.now()

    pickedPackage: -> return

    hurt: (direction) ->
      return if @dead

      @health--
      @knockback.set 10, 5
      @knockbackXDirection = direction

      @stun()

      if @health <= 0
        @dead = true

    _jump: ->
      if @onGround and not @onLadder
        @velocity.y = -@jumpForce

  module.exports = Mob
