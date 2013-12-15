define (require, exports, module) ->
  Player = require "player"
  Level = require "level"
  Enemy = require "enemy"
  Package = require "package"
  EventEmitter = require "lib/eventemitter"

  class Game extends EventEmitter
    horizontalScrollPadding: 0.2
    verticalScrollPadding: 0.3
    constructor: (@app) ->
      @level = new Level @app, this, "level-0"
      @package = new Package @app, this
      @player = new Player @app, this
      @player.position.set 280, 100

      @package.attachTo @player

      @mobs = [@player]

    update: (delta) ->
      @level.update delta

      for mob in @mobs
        mob.update delta

      @package.update delta

    addEnemy: ->
      enemy = new Enemy @app, this
      enemy.position.set Math.random() * @app.getWidth(), @level.floorHeight + Math.random() * @app.getHeight()

      @mobs.push enemy
      @emit "enemy_added", enemy

  module.exports = Game
