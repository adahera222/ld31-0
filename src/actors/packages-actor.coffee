define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  PackageActor = require "actors/package-actor"

  class LogoActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      {@spriteSheet} = @app
      @sprite = @spriteSheet.createSprite "logo.png"

      @width = @sprite.getWidth()
      @height = @sprite.getHeight()

      @packageActor = new PackageActor @app, @game
      @packages = []

      @lastPackage = Date.now()

    update: ->
      super

      for packageObject in @packages
        packageObject.position.y += packageObject.speed.y
        packageObject.position.y = Math.min(packageObject.position.y, packageObject.maxPosition.y)

      if Date.now() - @lastPackage >= 50 and @packages.length < 400
        stackHeight = Math.round(@packages.length / 50) * @packageActor.height / 2
        packageObject = {
          position: new LDFW.Vector2(@app.getWidth() * Math.random(), -50),
          maxPosition: new LDFW.Vector2(0, @app.getHeight() - 40 - stackHeight)
          speed: new LDFW.Vector2(0, 8),
          rotation: -45 + Math.random() * 45
        }
        @packages.push packageObject

        @lastPackage = Date.now()

    draw: (context) ->
      for packageObject in @packages
        @packageActor.sprite.rotation = packageObject.rotation
        @packageActor.draw context, packageObject.position.x, packageObject.position.y

  module.exports = LogoActor
