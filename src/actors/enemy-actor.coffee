define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  HumanActor = require "actors/human-actor"

  class EnemyActor extends HumanActor
    constructor: ->
      @spriteType = Math.round(Math.random() * 2)
      @spriteBasePath = "enemy/#{@spriteType}"

      super

  module.exports = EnemyActor
