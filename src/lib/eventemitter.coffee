define (require, exports, module) ->
  class EventEmitter
    emit: (event, args...) ->
      @events ?= {}

      return false unless @events[event]
      listener args... for listener in @events[event]
      return true

    bind: (event, listener) ->
      @events ?= {}

      (@events[event]?=[]).push listener
      return @

    once: (event, listener) ->
      fn = =>
        @unbind event, fn
        listener arguments...
      @on event, fn
      return @

    unbind: (event, listener) ->
      return @ unless @events[event]
      @events[event] = (l for l in @events[event] when l isnt listener)
      return @

    unbindAll: (event) ->
      delete @events[event]
      return @

    on: @::bind
    off: @::unbind
    addListener: @::bind
    removeListener: @::unbind

  module.exports = EventEmitter
