define (require, exports, module) ->
  LDFW = require "ldfw"
  Mob = require "mob"

  class Package extends Mob
    constructor: (@app, @game) ->
      super

      @attachedMob = null
      @jumpForce = 700

    attachTo: (@attachedMob) ->
    detach: ->
      @attachedMob = null

    update: (delta) ->
      if @attachedMob?
        @position.set @attachedMob.position
        @position.y -= @attachedMob.height
      else
        super

      if @onGround
        @velocity.x = 0

  module.exports = Package
