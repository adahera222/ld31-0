define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  ###
   * CloudsActor definition
  ###
  class CloudsActor extends LDFW.Actor
    constructor: ->
      super

      # Get the sprites atlas from our game
      @spritesAtlas = @game.getSpritesAtlas()

      @clouds = []
      for i in [0...10]
        index = Math.floor(Math.random() * 3)

        cloud = @spritesAtlas.createSprite "clouds/cloud-#{index}.png"
        cloud.setPosition(
          Math.random() * @game.getWidth() * 2,
          Math.random() * @game.getHeight() / 2
        )

        cloud.opacity = 0.05 + Math.random() * 0.03
        cloud.speedX = 50 + -Math.random() * 50

        cloud.parallaxFactor = [0.5, 0.1, 0.3][index]

        @clouds.push cloud

    update: (delta) ->
      for cloud in @clouds
        cloud.getPosition().add(cloud.speedX * delta * cloud.parallaxFactor, 0)

        if cloud.getPosition().getX() > @game.getWidth()
          cloud.setPosition(
            0 - cloud.getWidth(),
            Math.random() * @game.getHeight() / 2
          )

    draw: (context) ->
      context.save()

      for cloud in @clouds
        context.globalAlpha = cloud.opacity
        cloud.draw context,
          cloud.getPosition().getX(),
          cloud.getPosition().getY()

      context.restore()

  ###
   * Expose CloudsActor
  ###
  module.exports = CloudsActor
