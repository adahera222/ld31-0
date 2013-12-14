define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  HumanActor = require "actors/human-actor"

  class EnemyActor extends HumanActor
    spriteBasePath: "player"

  module.exports = EnemyActor
