define (require, exports, module) ->
  LDFW = require "ldfw"
  Mob = require "mob"

  class Player extends Mob
    constructor: (@app, @game) ->
      super

      {@package, @level} = @game
      @keyboard = new LDFW.Keyboard
      @minimumThrowingVelocity = 300

    update: (delta) ->
      super

      @_handleKeyboard()

      maxX = @level.scroll.x + @app.getWidth() - @game.scrollPadding * @app.getWidth()
      if @position.x > maxX
        @level.scroll.x +=  @position.x - maxX

      minX = @level.scroll.x + @game.scrollPadding * @app.getWidth()
      if @position.x < minX
        @level.scroll.x -= minX - @position.x

    _handleKeyboard: ->
      moveLeft = @keyboard.pressed @keyboard.Keys.LEFT
      moveRight = @keyboard.pressed @keyboard.Keys.RIGHT
      moveUp = @keyboard.pressed @keyboard.Keys.UP
      throwPackage = @keyboard.pressed @keyboard.Keys.SPACE

      if moveLeft
        @velocity.x = -@speed.x
        @direction = -1
      else if moveRight
        @velocity.x = @speed.x
        @direction = 1
      else
        @velocity.x = 0

      touchingLadder = @level.isMobTouchingLadder this
      if moveUp and @onGround and not touchingLadder
        @velocity.y = -@jumpForce
      else unless @package.attachedMob is this
        if moveUp and touchingLadder
          @velocity.y = -@speed.y
          @ignoreGravity = true
        else unless touchingLadder
          @ignoreGravity = false
        else if touchingLadder
          @velocity.y = 0
          @ignoreGravity = true

      if throwPackage and
        @package.attachedMob is this and
          @canInteractWithPackage()
            @lastPackageInteraction = Date.now()

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

  module.exports = Player
