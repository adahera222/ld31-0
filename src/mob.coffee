define (require, exports, module) ->
  LDFW = require "ldfw"

  class Mob
    constructor: (@app, @game) ->
      {@level} = @game

      @speed = new LDFW.Vector2 500, 0
      @position = new LDFW.Vector2
      @velocity = new LDFW.Vector2 0, 100
      @jumpForce = 1500

      @onGround = false

    update: (delta) ->
      gravityStep = @level.gravity.clone()
      gravityStep.multiply delta

      @velocity.add gravityStep

      velocityStep = @velocity.clone()
      velocityStep.multiply delta

      @position.add velocityStep

      if @position.y > 400
        @position.y = 400
        @velocity.y = 0

        @onGround = true
      else
        @onGround = false

  module.exports = Mob
