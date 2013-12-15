define (require, exports, module) ->
  class LevelParser
    constructor: (@app, @game, @level, @fileName) ->
      @image = @app.preloader.get "assets/levels/#{@fileName}.png"

    parse: ->
      @_prepareCanvas()

      @level.width = @canvas.width
      @level.height = @canvas.height

      @_findPlatforms()
      @_findLadders()
      @_findExits()
      @_findEnemies()

    _prepareCanvas: ->
      @canvas = document.createElement "canvas"
      @canvas.width = @image.width
      @canvas.height = @image.height

      @context = @canvas.getContext "2d"

      @context.drawImage @image, 0, 0

    _findPlatforms: ->
      imageData = @context.getImageData 0, 0, @canvas.width, @canvas.height
      imageData = imageData.data

      onPlatform = false
      platformWidth = 0
      platformX = 0
      for y in [0...@canvas.height]
        for x in [0...@canvas.width]
          index = (@canvas.width * y + x) * 4

          rgb = [
            imageData[index],
            imageData[index + 1],
            imageData[index + 2]
          ]

          isPlatform = rgb[0] is 0 and rgb[1] is 0 and rgb[2] is 255
          if isPlatform
            # Platform!
            platformWidth++
            unless onPlatform
              platformX = x

            onPlatform = true
          if (not isPlatform and onPlatform) or (onPlatform and x is @canvas.width - 1)
            onPlatform = false
            @level.addPlatform platformX, @canvas.height - y, platformWidth
            platformWidth = 0

    _findLadders: ->
      imageData = @context.getImageData 0, 0, @canvas.width, @canvas.height
      imageData = imageData.data

      for y in [0...@canvas.height]
        for x in [0...@canvas.width]
          index = (@canvas.width * y + x) * 4

          rgb = [
            imageData[index],
            imageData[index + 1],
            imageData[index + 2]
          ]

          if rgb[0] is 0 and rgb[1] is 255 and rgb[2] is 0
            # Ladder!
            @level.addLadder x, y

    _findExits: ->
      imageData = @context.getImageData 0, 0, @canvas.width, @canvas.height
      imageData = imageData.data

      for y in [0...@canvas.height]
        for x in [0...@canvas.width]
          index = (@canvas.width * y + x) * 4

          rgb = [
            imageData[index],
            imageData[index + 1],
            imageData[index + 2]
          ]

          if rgb[0] is 255 and rgb[1] is 0 and rgb[2] is 0
            # Exit!
            @level.addExit x, y

    _findEnemies: ->
      imageData = @context.getImageData 0, 0, @canvas.width, @canvas.height
      imageData = imageData.data

      for y in [0...@canvas.height]
        for x in [0...@canvas.width]
          index = (@canvas.width * y + x) * 4

          rgb = [
            imageData[index],
            imageData[index + 1],
            imageData[index + 2]
          ]

          if rgb[0] is 255 and rgb[1] is 178 and rgb[2] is 0
            @game.addEnemy x, y

  module.exports = LevelParser
