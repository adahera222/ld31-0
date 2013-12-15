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

      @lastAttachment = Date.now()

    attachTo: (@attachedMob) ->
      @lastAttachment = Date.now()

    detach: -> @attachedMob = null

    onIntersect: (obj) ->
      return if @attachedMob is obj
      return if obj.stunned

      if obj instanceof Mob
        lastAttached = @attachedMob

        @attachTo obj
        obj.pickedPackage()
        lastAttached?.lostPackage()

    update: (delta) ->
      if @attachedMob?
        @position.set @attachedMob.position
        @position.y -= @attachedMob.height
      else
        super

      if @onGround
        @velocity.x = 0

  module.exports = Package
