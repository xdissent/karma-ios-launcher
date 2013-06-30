# # index

iosctrl = require 'iosctrl'

class IOSLauncher
  constructor: (@id) ->
    @name = 'iOS'
    @captured = false

  start: (url) ->
    @ios = iosctrl "#{url}?id=#{@id}"
  kill: (done) ->
    @ios.close() unless @ios.state is 'ready'
    setTimeout done, 10000

  markCaptured: -> @captured = true
  isCaptured: -> @captured

exports["launcher:iOS"] = ['type', (id) -> new IOSLauncher id]