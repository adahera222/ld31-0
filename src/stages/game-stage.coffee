define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  LevelActor = require "actors/level-actor"
  PlayerActor = require "actors/player-actor"
  EnemyActor = require "actors/enemy-actor"
  PackageActor = require "actors/package-actor"

  Player = require "player"
  Mob = require "mob"

  ###
   * GameStage definition
  ###
  class GameStage extends LDFW.Stage
    constructor: (@app, @game) ->
      super @game

      @levelActor = new LevelActor @app, @game
      @addActor @levelActor

      @playerActor = new PlayerActor @app, @game, @game.player
      @game.player.actor = @playerActor
      @addActor @playerActor

      @packageActor = new PackageActor @app, @game
      @addActor @packageActor

      @mobActors = [@playerActor]
      @game.on "enemy_added", (enemy) =>
        mobActor = new EnemyActor @app, @game, enemy
        enemy.actor = mobActor

        @mobActors.push mobActor
        @addActor mobActor

    update: (delta) ->
      super

      # Exit intersection check
      {level} = @game
      packageObject = @game.package
      deadMobs = []

      packageObject = @packageActor.package
      for mobActor in @mobActors
        if mobActor.dataObject.dead
          deadMobs.push mobActor

        if mobActor.dataObject is packageObject.attachedMob
          exitActor = @levelActor.exitActor
          for exit in level.exits
            position = exit.getRealPosition()
            exitRect = {
              x: position.x,
              y: position.y,
              width: exitActor.width,
              height: exitActor.height
            }

            if mobActor.intersectsWithRect exitRect
              @game.gameEnded
                winner: mobActor.dataObject

        # Package intersection check
        packageFree = !packageObject.attachedMob
        intersectsWithPackage = mobActor.intersectsWith @packageActor

        unless packageFree
          intersectsWithPackageHolder = mobActor.intersectsWith packageObject.attachedMob.actor

        pickPackage = (
          (packageFree and intersectsWithPackage and mobActor.dataObject.canPickPackage()) or
            (intersectsWithPackageHolder and not mobActor.dataObject.isSafe() and
              (
                (packageObject.attachedMob instanceof Player and mobActor.dataObject instanceof Mob) or
                (packageObject.attachedMob instanceof Mob and mobActor.dataObject instanceof Player)
              )
            )
          )

        if pickPackage
          packageObject = @packageActor.package
          packageObject.onIntersect mobActor.dataObject

      for mob in deadMobs
        @mobActors.splice @mobActors.indexOf(mob), 1

    draw: (context) ->
      {width, height} = context.canvas

      gradient = context.createLinearGradient 0, 0, 0, height
      gradient.addColorStop 0, "#73a7d0"
      gradient.addColorStop 1, "#568bb4"

      context.save()
      context.fillStyle = gradient
      context.fillRect 0, 0, width, height
      context.restore()

      super

      for mobActor in @mobActors
        mobActor.draw context

      @packageActor.draw context

  ###
   * Expose GameStage
  ###
  module.exports = GameStage
