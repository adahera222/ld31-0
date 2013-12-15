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
      packageObject = @packageActor.package
      for mobActor in @mobActors
        packageFree = !packageObject.attachedMob
        intersectsWithPackage = mobActor.intersectsWith @packageActor

        unless packageFree
          intersectsWithPackageHolder = mobActor.intersectsWith packageObject.attachedMob.actor

        pickPackage = (
          (packageFree and intersectsWithPackage and mobActor.dataObject.canPickPackage()) or
            (intersectsWithPackageHolder and
              (
                (packageObject.attachedMob instanceof Player and mobActor.dataObject instanceof Mob) or
                (packageObject.attachedMob instanceof Mob and mobActor.dataObject instanceof Player)
              )
            )
          )

        if pickPackage
          packageObject = @packageActor.package
          packageObject.onIntersect mobActor.dataObject

    draw: (context) ->
      super

      {width, height} = context.canvas

      context.fillStyle = "#73a7d0"
      context.fillRect 0, 0, width, height

      @levelActor.draw context

      for mobActor in @mobActors
        mobActor.draw context

      @packageActor.draw context

  ###
   * Expose GameStage
  ###
  module.exports = GameStage
