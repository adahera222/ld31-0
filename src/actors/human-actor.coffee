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
      if @game?
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

      @attentionSprite = @spriteSheet.createSprite "attention.png"
      @confusionSprite = @spriteSheet.createSprite "confusion.png"

      @width = @holdingIdleSprite.getWidth()
      @height = @holdingIdleSprite.getHeight()

      if @dataObject?
        @dataObject.width = @width
        @dataObject.height = @height

    update: (delta) ->
      super
      if @dataObject?
        @position.set @dataObject.position

      @holdingRunningSprite.update delta
      @runningSprite.update delta
      @offgroundSprite.update delta

      @blinkTimer += delta

    hasPackage: ->
      return @package.attachedMob is @dataObject

    isOnGround: ->
      @dataObject?.onGround

    drawPunch: ->
      @dataObject? and
        @dataObject.lastPunch? and
        Date.now() - @dataObject.lastPunch <= 100 and
        @punchSprite?

    isRunning: ->
      @dataObject.velocity.x isnt 0

    drawMirrored: ->
      @dataObject?.direction is -1

    draw: (context, dx, dy) ->
      unless dx? and dy?
        level = @game.level

        dx = @position.x - level.scroll.x
        dy = @position.y - @height - level.scroll.y

      mirrored = @drawMirrored()

      sprite = @idleSprite
      if not @isOnGround() and
        not @hasPackage()
          sprite = @offgroundSprite
      else if @drawPunch()
          sprite = @punchSprite
          unless mirrored
            dx -= sprite.getWidth() - @idleSprite.getWidth()
      else if @isRunning()
        if @hasPackage()
          sprite = @holdingRunningSprite
        else
          sprite = @runningSprite
      else
        if @hasPackage()
          sprite = @holdingIdleSprite
        else
          sprite = @idleSprite

      context.save()
      alpha = 1

      if @dataObject?.stunned and @blinkTimer >= 0.2
        @blinking = !@blinking
        @blinkTimer = 0

      if @blinking
        alpha = 0.5

      context.save()
      context.globalAlpha = alpha

      sprite.draw context, dx, dy, mirrored
      context.restore()

      if @dataObject?
        if Date.now() - @dataObject.attentionGainedAt < 1000
          @attentionSprite.draw context, dx, dy - 30

        if @dataObject.stunned
          @confusionSprite.draw context, dx, dy - 30

    intersectsWith: (actor) ->
      return not (actor.position.x > @position.x + @width or
        actor.position.x + actor.width < @position.x or
        actor.position.y > @position.y or
        actor.position.y + actor.height < @position.y - @height)

    intersectsWithRect: (rect) ->
      return not (rect.x > @position.x + @width or
        rect.x + rect.width < @position.x or
        rect.y > @position.y or
        rect.y + rect.height < @position.y - @height)

  module.exports = PlayerActor
