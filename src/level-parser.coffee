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

          if rgb[0] is 0 and rgb[1] is 0 and rgb[2] is 255
            # Platform!
            platformWidth++
            unless onPlatform
              platformX = x

            onPlatform = true
          else if onPlatform
            onPlatform = false
            @level.addPlatform platformX, y, platformWidth
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

  module.exports = LevelParser
