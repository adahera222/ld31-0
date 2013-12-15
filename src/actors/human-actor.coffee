define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Player = require "player"

  class PlayerActor extends LDFW.Actor
    spriteBasePath: "none"
    constructor: (@app, @game, @dataObject) ->
      super @game

      {@spriteSheet} = @app
      {@package} = @game

      @blinkTimer = 0
      @blinking = false

      @holdingIdleSprite = @spriteSheet.createSprite "#{@spriteBasePath}/holding-idle.png"
      @holdingRunningSprite = @spriteSheet.createAnimSprite "#{@spriteBasePath}/holding-running.png", 2, 0.05

      @idleSprite = @spriteSheet.createSprite "#{@spriteBasePath}/idle.png"
      @runningSprite = @spriteSheet.createAnimSprite "#{@spriteBasePath}/run.png", 2, 0.05

      @offgroundSprite = @spriteSheet.createAnimSprite "#{@spriteBasePath}/offground.png", 3, 0.2

      if this.dataObject instanceof Player
        @punchSprite = @spriteSheet.createSprite "#{@spriteBasePath}/punch.png"

      @width = @holdingIdleSprite.getWidth()
      @height = @holdingIdleSprite.getHeight()

      @dataObject.width = @width
      @dataObject.height = @height

    update: (delta) ->
      super
      @position.set @dataObject.position

      @holdingRunningSprite.update delta
      @runningSprite.update delta
      @offgroundSprite.update delta

      @blinkTimer += delta

    draw: (context) ->
      level = @game.level

      dx = @position.x - level.scroll.x
      dy = @position.y - @height - level.scroll.y

      mirrored = @dataObject.direction is -1

      sprite = @idleSprite
      if not @dataObject.onGround and
        @package.attachedMob isnt @dataObject
          sprite = @offgroundSprite
      else if @dataObject.lastPunch? and
        Date.now() - @dataObject.lastPunch <= 100
          sprite = @punchSprite
          unless mirrored
            dx -= sprite.getWidth() - @idleSprite.getWidth()
      else if @dataObject.velocity.x isnt 0
        if @package.attachedMob is @dataObject
          sprite = @holdingRunningSprite
        else
          sprite = @runningSprite
      else
        if @package.attachedMob is @dataObject
          sprite = @holdingIdleSprite
        else
          sprite = @idleSprite

      # I'm dumb. <-- Definitely.
      context.save()
      alpha = 1

      if @dataObject.stunned and @blinkTimer >= 0.2
        @blinking = !@blinking
        @blinkTimer = 0

      if @blinking
        alpha = 0.5

      context.save()
      context.globalAlpha = alpha

      sprite.draw context, dx, dy, mirrored
      context.restore()

    intersectsWith: (actor) ->
      return not (actor.position.x > @position.x + @width or
        actor.position.x + actor.width < @position.x or
        actor.position.y > @position.y or
        actor.position.y + actor.height < @position.y - @height)

  module.exports = PlayerActor
