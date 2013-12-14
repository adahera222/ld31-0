define (require, exports, module) ->
  LDFW = require "ldfw"
  Mob = require "mob"

  class Player extends Mob
    constructor: (@app, @game) ->
      super

      {@package} = @game
      @keyboard = new LDFW.Keyboard

      @width = 32
      @height = 64

    update: (delta) ->
      super

      @_handleKeyboard()

    _handleKeyboard: ->
      moveLeft = @keyboard.pressed @keyboard.Keys.LEFT
      moveRight = @keyboard.pressed @keyboard.Keys.RIGHT
      jump = @keyboard.pressed @keyboard.Keys.UP
      throwPackage = @keyboard.pressed @keyboard.Keys.SPACE

      if moveLeft
        @velocity.x = -@speed.x
      else if moveRight
        @velocity.x = @speed.x
      else
        @velocity.x = 0

      if jump and @onGround
        @velocity.y = -@jumpForce

      if throwPackage and @package.attachedMob is this
        @package.detach()
        @package.velocity.set @velocity
        @package.velocity.y -= @package.jumpForce

  module.exports = Player
