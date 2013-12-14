define (require, exports, module) ->
  LDFW = require "ldfw"

  class PhysicsObject
    constructor: (@app, @game) ->
      {@level} = @game

      @speed = new LDFW.Vector2 500, 0
      @position = new LDFW.Vector2
      @velocity = new LDFW.Vector2 0, 100
      @jumpForce = 1500

      @width = 0
      @height = 0

      @onGround = false

    update: (delta) ->
      gravityStep = @level.gravity.clone()
      gravityStep.multiply delta

      @velocity.add gravityStep

      velocityStep = @velocity.clone()
      velocityStep.multiply delta

      aspiredPosition = @position.clone().add velocityStep

      boundaries = @level.getBoundariesForObject this
      @_handleYMovement aspiredPosition, boundaries

      @position.set aspiredPosition

    _handleYMovement: (position, boundaries) ->
      if position.y >= boundaries.y.max
        position.y = boundaries.y.max
        @velocity.y = 0
        @onGround = true
      else
        @onGround = false



  module.exports = PhysicsObject
