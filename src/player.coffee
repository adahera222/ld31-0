define (require, exports, module) ->
  JUMP_FORCE = -700

  LDFW = require "ldfw"

  class Player
    constructor: (@game) ->
      @position = new LDFW.Vector2
      @velocity = new LDFW.Vector2
      @speed = new LDFW.Vector2(400, 0)

      @onGround = false
      @direction = 1

      @keyboard = new LDFW.Keyboard

    getPosition: -> @position
    setPosition: -> @position.set.apply @position, arguments

    update: (delta) ->
      @handleKeyboard()

      aspiredPosition = @getAspiredPosition delta
      @handleYMovement aspiredPosition

      @position.set aspiredPosition

    getAspiredPosition: (delta) ->
      gravity = @game.getGravity().clone()
      gravityStep = gravity.multiply delta

      @velocity.add gravityStep
      velocityStep = @velocity.clone().multiply delta

      if @velocity.getX() > 0
        @direction = 1
      else if @velocity.getX() < 0
        direction = -1

      return @position.clone().add velocityStep

    handleYMovement: (aspiredPosition) ->
      maxY = 324
      if aspiredPosition.getY() >= maxY
        aspiredPosition.setY maxY

        @onGround = true
        @velocity.setY 0
      else
        @onGround = false

    handleKeyboard: ->
      if @keyboard.pressed(@keyboard.Keys.RIGHT) or
        @keyboard.pressed(@keyboard.Keys.D)
          @velocity.setX @speed.x
      else if @keyboard.pressed(@keyboard.Keys.LEFT) or
        @keyboard.pressed(@keyboard.Keys.A)
          @velocity.setX -@speed.x
      else
        @velocity.setX 0

      if @keyboard.upPressed() and @onGround
        @velocity.setY JUMP_FORCE

  module.exports = Player
