define (require, exports, module) ->
  LDFW = require "ldfw"

  class Player
    constructor: (@app, @game) ->
      @level = @game.level

      @keyboard = new LDFW.Keyboard

      @speed = new LDFW.Vector2 500, 0
      @position = new LDFW.Vector2
      @velocity = new LDFW.Vector2 0, 100
      @jumpForce = 700

      @onGround = false

    update: (delta) ->
      @_handleKeyboard()

      gravityStep = @level.gravity.clone()
      gravityStep.multiply delta

      @velocity.add gravityStep

      velocityStep = @velocity.clone()
      velocityStep.multiply delta

      @position.add velocityStep

      if @position.y >= 400
        @position.y = 400
        @velocity.y = 0

        @onGround = true
      else
        @onGround = false

    _handleKeyboard: ->
      moveLeft = @keyboard.leftPressed()
      moveRight = @keyboard.rightPressed()
      jump = @keyboard.upPressed()

      if moveLeft
        @velocity.x = -@speed.x
      else if moveRight
        @velocity.x = @speed.x
      else
        @velocity.x = 0

      if jump and @onGround
        @velocity.y = -@jumpForce

  module.exports = Player
