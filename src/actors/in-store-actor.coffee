define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  MobActor = require "actors/enemy-actor"
  PlayerActor = require "actors/player-actor"

  class InStoreActor extends LDFW.Actor
    constructor: (@app) ->
      super

      {@spriteSheet} = @app

      @counterSprite = @spriteSheet.createSprite "store/counter.png"
      @roomSprite = @spriteSheet.createSprite "store/room.png"
      @sellerSprite = @spriteSheet.createSprite "store/seller.png"

      @packageSprite = @spriteSheet.createSprite "store/package.png"

      @msgOnlyOneSprite = @spriteSheet.createSprite "store/msg-only-one.png"
      @msgLastOneSprite = @spriteSheet.createSprite "store/msg-last-one.png"

      @attentionSprite = @spriteSheet.createSprite "attention.png"

      @stockPackages = 6

      @opacity = 1
      @ended = false

      @mobActors = []
      for i in [0...25]
        ((mobActor) =>
          # Mock some states...
          @_mockActorStates mobActor

          mobActor.position = new LDFW.Vector2 i * 23, 0
          mobActor.velocity = new LDFW.Vector2 0, 0
          mobActor.minX = mobActor.position.x
          mobActor.attention = false

          @mobActors.push mobActor
        )(new MobActor @app)

      @playerActor = new PlayerActor @app
      @playerActor.position = new LDFW.Vector2 8 * 23, 0
      @playerActor.velocity = new LDFW.Vector2 0, 0
      @playerActor.minX = @playerActor.position.x
      @_mockActorStates @playerActor

      @mobActors[5] = @playerActor

      @lastPackage = Date.now()
      @lastMob = Date.now()

      @drawYOGOMessage = true
      @drawLastOneMessage = false

    update: (delta) ->
      super

      mobBuyDuration = 1500 # (Naming is hard.)

      for mob in @mobActors
        mob.position.x += mob.velocity.x * delta
        mob.position.x = Math.max mob.position.x, mob.minX

        if mob.position.x is mob.minX
          mob.isRunning = -> false

        mob.update delta

      @drawYOGOMessage = Date.now() - @lastMob < mobBuyDuration - 200

      if Date.now() - @lastMob > mobBuyDuration and @stockPackages > 1
        mobIndex = 9 - @stockPackages

        mob = @mobActors[mobIndex]
        mob.velocity.x = 250
        mob.drawMirrored = -> false
        mob.isRunning = -> true

        # Move the other mobs
        for mob, i in @mobActors.slice(mobIndex + 1, -1)
          mob.velocity.x = -250
          mob.minX = i * 23
          mob.isRunning = -> true

        @lastMob = Date.now()

      if Date.now() - @lastPackage > mobBuyDuration and @stockPackages > 1
        @stockPackages--
        @lastPackage = Date.now()

      timePassed = Date.now() - @lastMob
      if @stockPackages <= 1 and timePassed > 2000
        @drawLastOneMessage = true

        if timePassed > 4000
          @playerActor.velocity.x = 500
          @playerActor.isRunning = -> true
          @playerActor.drawMirrored = -> false

          @stockPackages--
          @stockPackages = Math.max 0, @stockPackages

        if timePassed > 5000
          for mob in @mobActors
            mob.attention = true

        if timePassed > 6000
          for mob in @mobActors
            mob.attention = false
            mob.velocity.x = 500 + Math.random() * 200
            mob.isRunning = -> true
            mob.drawMirrored = -> false

          @ended = true

    draw: (context) ->
      context.save()
      context.globalAlpha = @opacity

      roomOffset = @app.getHeight() / 2 - @roomSprite.getHeight() / 2

      @roomSprite.draw context, 0, roomOffset
      @sellerSprite.draw context, 134, roomOffset + @roomSprite.getHeight() - @sellerSprite.getHeight()
      @counterSprite.draw context, 74, roomOffset + @roomSprite.getHeight() - @counterSprite.getHeight()

      @_drawStockPackages context
      @_drawMobs context
      @_drawMessages context

      context.restore()

    _drawMessages: (context) ->
      if @drawYOGOMessage
        @msgOnlyOneSprite.draw context, 65, 245
      if @drawLastOneMessage
        @msgLastOneSprite.draw context, 88, 245

    _drawMobs: (context) ->
      roomOffset = @app.getHeight() / 2 - @roomSprite.getHeight() / 2

      for mob in @mobActors
        mob.draw context,
          200 + mob.position.x,
          roomOffset + @roomSprite.getHeight() - mob.height

        if mob.attention
          @attentionSprite.draw context,
            200 + mob.position.x,
            roomOffset + @roomSprite.getHeight() - mob.height - 30

    _drawStockPackages: (context) ->
      roomOffset = @app.getHeight() / 2 - @roomSprite.getHeight() / 2

      for i in [0...@stockPackages]
        x = 16 + Math.floor(i / 3) * @packageSprite.getWidth()
        y = roomOffset + @roomSprite.getHeight() - (i % 3) * @packageSprite.getHeight() - @packageSprite.getHeight()

        @packageSprite.draw context, x, y

    _mockActorStates: (mobActor) ->
      mobActor.hasPackage = -> mobActor.holdsPackage
      mobActor.drawPunch = -> false
      mobActor.isOnGround = -> true
      mobActor.isRunning = -> false
      mobActor.drawMirrored = -> true

  module.exports = InStoreActor
