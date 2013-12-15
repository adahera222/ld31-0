define (require, exports, module) ->
  LDFW = require "ldfw"

  Player = require "player"
  Level = require "level"
  Enemy = require "enemy"
  Package = require "package"
  EventEmitter = require "lib/eventemitter"

  class Game extends EventEmitter
    horizontalScrollPadding: 0.4
    verticalScrollPadding: 0.5
    constructor: (@app) ->
      @mobs = []

      @spawn = new LDFW.Vector2 400, 100

      @level = new Level @app, this, "level-0"
      @package = new Package @app, this

      @player = new Player @app, this

    spawnPlayer: ->
      @player.position.set @spawn
      @mobs.push @player

      @package.attachTo @player

    setSpawn: ->
      @spawn.set.apply @spawn, arguments
      @spawn.multiply Level.GRID_SIZE
      @spawn.y = @app.getHeight() - @spawn.y

    update: (delta) ->
      @level.update delta

      deadMobs = []
      for mob in @mobs
        mob.update delta
        deadMobs.push(mob) if mob.dead

      for mob in deadMobs
        @mobs.splice @mobs.indexOf(mob), 1

      @package.update delta

    addEnemy: (x, y) ->
      enemy = new Enemy @app, this
      enemy.position.set x, y
      enemy.position.multiply Level.GRID_SIZE
      enemy.position.y = @app.getHeight() - enemy.position.y

      @mobs.push enemy
      @emit "enemy_added", enemy

    nextToMob: (mob) ->
      for otherMob in @mobs when otherMob isnt mob
        if otherMob.actor.intersectsWith mob.actor
          # Direction check
          rightDirection = (mob.direction is 1 and
            otherMob.position >= mob.position) or
            (mob.direction is -1 and
            otherMob.position <= mob.position)
          if rightDirection
            return otherMob

      return false


  module.exports = Game
