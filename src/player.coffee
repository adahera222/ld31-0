define (require, exports, module) ->
  LDFW = require "ldfw"
  Mob = require "mob"
  Level = require "level"

  class Player extends Mob
    constructor: (@app, @game) ->
      super

      {@package, @level} = @game
      @keyboard = new LDFW.Keyboard
      @minimumThrowingVelocity = 300

    update: (delta) ->
      super

      @_handleKeyboard()
      @_handleLevelScrolling()

    _handleKeyboard: ->
      moveLeft = @keyboard.pressed @keyboard.Keys.LEFT
      moveRight = @keyboard.pressed @keyboard.Keys.RIGHT
      moveUp = @keyboard.pressed @keyboard.Keys.UP
      throwPackage = @keyboard.pressed @keyboard.Keys.SPACE


      if moveLeft and not @stunned
        @velocity.x = -@speed.x
        @direction = -1
      else if moveRight and not @stunned
        @velocity.x = @speed.x
        @direction = 1
      else
        @velocity.x = 0

      touchingLadder = @level.isMobTouchingLadder this

      if moveUp and touchingLadder and @package.attachedMob isnt this and not @stunned
        @ignoreGravity = true
        @onLadder = true

      if @onLadder
        if moveUp and not @stunned
          @velocity.y = -@speed.y
        else
          @velocity.y = 0

      if @onLadder and not touchingLadder
        @ignoreGravity = false
        @onLadder = false

      if moveUp and not @stunned
        @_jump()

      if throwPackage and not @stunned and
        @package.attachedMob is this
          @droppedPackage()

          @package.detach()
          @package.velocity.set @velocity
          @package.velocity.y -= @package.jumpForce

          # Minimum X velocity (so we don't throw it straight upwards)
          if @package.velocity.x > 0
            @package.velocity.x = Math.max @package.velocity.x, @minimumThrowingVelocity
          else if @package.velocity.x < 0
            @package.velocity.x = Math.min @package.velocity.x, -@minimumThrowingVelocity
          else
            @package.velocity.x = @direction * @minimumThrowingVelocity

    # Todo: Move this to the level.
    _handleLevelScrolling: ->
      maxX = @level.scroll.x + @app.getWidth() - @game.horizontalScrollPadding * @app.getWidth()
      if @position.x > maxX
        @level.scroll.x +=  @position.x - maxX

      minX = @level.scroll.x + @game.horizontalScrollPadding * @app.getWidth()
      if @position.x < minX
        @level.scroll.x -= minX - @position.x

      minX = 0
      @level.scroll.x = Math.max 0, @level.scroll.x
      @level.scroll.x = Math.min (@level.width * Level.GRID_SIZE) - @app.getWidth(), @level.scroll.x

      scrollPadding = @game.verticalScrollPadding * @app.getHeight()
      minY = scrollPadding
      if @position.y < minY
        @level.scroll.y = @position.y - scrollPadding

    droppedPackage: ->
      @lastPackageInteraction = Date.now()

    pickedPackage: ->
      @droppedPackage()

  module.exports = Player
