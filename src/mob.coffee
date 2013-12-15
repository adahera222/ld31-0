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

    lostPackage: ->
      @stunned = true
      @stunStart = Date.now()

    update: ->
      super

      if @stunned and
        Date.now() - @stunStart > @stunDuration
          @stunned = false

    _jump: ->
      if @onGround and not @onLadder
        @velocity.y = -@jumpForce

  module.exports = Mob
