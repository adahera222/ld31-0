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

      if moveUp and touchingLadder and @package.attachedMob isnt this
        @ignoreGravity = true
        @onLadder = true

      if @onLadder
        if moveUp
          @velocity.y = -@speed.y
        else
          @velocity.y = 0

      if @onLadder and not touchingLadder
        @ignoreGravity = false
        @onLadder = false

      if moveUp and @onGround and not @onLadder
        @velocity.y = -@jumpForce

      if throwPackage and
        @package.attachedMob is this and
          @canInteractWithPackage()
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

    droppedPackage: ->
      @lastPackageInteraction = Date.now()

    pickedPackage: ->
      @droppedPackage()

  module.exports = Player
