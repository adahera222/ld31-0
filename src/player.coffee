define (require, exports, module) ->
  LDFW = require "ldfw"

  class Player
    constructor: (@game) ->
      @position = new LDFW.Vector2(0, 0)
      @velocity = new LDFW.Vector2()

      @onGround = false
      @direction = 1

    getPosition: -> @position
    setPosition: -> @position.set.apply @position, arguments

    update: (delta) ->
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

  module.exports = Player
