define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class PlayerActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      {@spriteSheet} = @app

      @holdingIdleSprite = @spriteSheet.createSprite "player/holding-idle.png"
      @holdingRunningSprite = @spriteSheet.createAnimSprite "player/holding-running.png", 2, 0.05

      @idleSprite = @spriteSheet.createSprite "player/idle.png"
      @runningSprite = @spriteSheet.createAnimSprite "player/run.png", 2, 0.05

      {@player, @package} = @game
      @dataObject = @player

      @width = @holdingIdleSprite.getWidth()
      @height = @holdingIdleSprite.getHeight()

      @player.width = @width
      @player.height = @height

    update: (delta) ->
      super
      @position.set @player.position

      @holdingRunningSprite.update delta
      @runningSprite.update delta

    draw: (context) ->
      dx = @position.x
      dy = @position.y - @height

      mirrored = @player.direction is -1

      sprite = @idleSprite
      if @player.velocity.x isnt 0
        if @package.attachedMob is @player
          sprite = @holdingRunningSprite
        else
          sprite = @runningSprite
      else
        if @package.attachedMob is @player
          sprite = @holdingIdleSprite
        else
          sprite = @idleSprite

      sprite.draw context, dx, dy, mirrored

    intersectsWith: (actor) ->
      return not (actor.position.x > @position.x + @width or
        actor.position.x + actor.width < @position.x or
        actor.position.y > @position.y or
        actor.position.y + actor.height < @position.y - @height)

  module.exports = PlayerActor
