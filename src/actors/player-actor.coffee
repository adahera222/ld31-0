define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  HumanActor = require "actors/human-actor"

  class PlayerActor extends HumanActor
    spriteBasePath: "player"

  module.exports = PlayerActor
