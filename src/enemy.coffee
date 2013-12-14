define (require, exports, module) ->
  LDFW = require "ldfw"
  Mob = require "mob"

  class Enemy extends Mob
    constructor: (@app, @game) ->
      super

      {@package, @level} = @game

    update: ->
      super
      # Put some magic intelligence here.

    droppedPackage: ->
      @lastPackageInteraction = Date.now()

    pickedPackage: ->
      @droppedPackage()

  module.exports = Enemy
