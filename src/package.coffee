define (require, exports, module) ->
  LDFW = require "ldfw"
  PhysicsObject = require "physics-object"
  Mob = require "mob"

  class Package extends PhysicsObject
    constructor: (@app, @game) ->
      super

      @attachedMob = null
      @jumpForce = 300

      @width = 0
      @height = 0

    attachTo: (@attachedMob) -> return
    detach: -> @attachedMob = null

    onIntersect: (obj) ->
      return if @attachedMob is obj

      if obj instanceof Mob and
        obj.canInteractWithPackage()
          lastAttached = @attachedMob

          @attachTo obj
          obj.pickedPackage()
          lastAttached.lostPackage()

    update: (delta) ->
      if @attachedMob?
        @position.set @attachedMob.position
        @position.y -= @attachedMob.height
      else
        super

      if @onGround
        @velocity.x = 0

  module.exports = Package
