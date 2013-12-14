define (require, exports, module) ->
  LDFW = require "ldfw"
  PhysicsObject = require "physics-object"

  class Package extends PhysicsObject
    constructor: (@app, @game) ->
      super

      @attachedMob = null
      @jumpForce = 700

    attachTo: (@attachedMob) -> return
    detach: -> @attachedMob = null

    update: (delta) ->
      if @attachedMob?
        @position.set @attachedMob.position
        @position.y -= 64
      else
        super

      if @onGround
        @velocity.x = 0

  module.exports = Package
