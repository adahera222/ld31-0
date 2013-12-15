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

      @stockPackages = 9

      @mobActors = []
      for i in [0...20]
        ((mobActor) =>
          # Mock some states...
          @_mockActorStates mobActor

          mobActor.position = new LDFW.Vector2 i * 23, 0
          mobActor.velocity = new LDFW.Vector2 0, 0
          mobActor.minX = mobActor.position.x

          @mobActors.push mobActor
        )(new MobActor @app)

      @mobActors[8] = new PlayerActor @app
      @mobActors[8].position = new LDFW.Vector2 8 * 23, 0
      @mobActors[8].velocity = new LDFW.Vector2 0, 0
      @mobActors[8].minX = @mobActors[8].position.x
      @_mockActorStates @mobActors[8]

      @lastPackage = Date.now()
      @lastMob = Date.now()

    update: (delta) ->
      super

      for mob in @mobActors
        mob.position.x += mob.velocity.x * delta
        mob.position.x = Math.max mob.position.x, mob.minX

        if mob.position.x is mob.minX
          mob.isRunning = -> false

        mob.update delta

      if Date.now() - @lastMob > 1000 and @stockPackages > 1
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

      if Date.now() - @lastPackage > 1000 and @stockPackages > 1
        @stockPackages--
        @lastPackage = Date.now()

    draw: (context) ->
      roomOffset = @app.getHeight() / 2 - @roomSprite.getHeight() / 2

      @roomSprite.draw context, 0, roomOffset
      @sellerSprite.draw context, 134, roomOffset + @roomSprite.getHeight() - @sellerSprite.getHeight()
      @counterSprite.draw context, 74, roomOffset + @roomSprite.getHeight() - @counterSprite.getHeight()

      @_drawStockPackages context
      @_drawMobs context

    _drawMobs: (context) ->
      roomOffset = @app.getHeight() / 2 - @roomSprite.getHeight() / 2

      for mob in @mobActors
        mob.draw context,
          200 + mob.position.x,
          roomOffset + @roomSprite.getHeight() - mob.height

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
