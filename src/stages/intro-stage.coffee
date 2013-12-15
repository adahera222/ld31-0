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

      @fadeoutTimePassed = 0
      @ended = false

      @keyboard = new LDFW.Keyboard
      @timePassed = 0

    update: (delta) ->
      super

      @timePassed += delta

      if @storeActor.ended
        @removeActor @storeActor
        @addActor @inStoreActor

      if @inStoreActor.ended
        @inStoreActor.opacity -= delta
        @inStoreActor.opacity = Math.max 0, @inStoreActor.opacity

        @fadeoutTimePassed += delta

      if @fadeoutTimePassed >= 1 or
        (@keyboard.pressed(@keyboard.Keys.ENTER) and @timePassed > 1)
          @app.switchToInstructionsScreen()

  ###
   * Expose IntroStage
  ###
  module.exports = IntroStage
