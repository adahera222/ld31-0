define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  StoreActor = require "actors/store-actor"
  InStoreActor = require "actors/in-store-actor"

  ###
   * IntroStage definition
  ###
  class IntroStage extends LDFW.Stage
    constructor: (@app) ->
      super

      @storeActor = new StoreActor @app
      @inStoreActor = new InStoreActor @app
      @addActor @inStoreActor

    update: (delta) ->
      super

      if @storeActor.ended
        @removeActor @storeActor
        @addActor @inStoreActor

    draw: (context) ->
      super


  ###
   * Expose IntroStage
  ###
  module.exports = IntroStage
