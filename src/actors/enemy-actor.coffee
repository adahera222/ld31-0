define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  HumanActor = require "actors/human-actor"

  class EnemyActor extends HumanActor
    constructor: ->
      @spriteBasePath = "enemy/0"

      super

  module.exports = EnemyActor
