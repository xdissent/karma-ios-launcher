# # index

iosctrl = require 'iosctrl'

class IOSLauncher
  constructor: (@id) ->
    @name = 'iOS'
    @captured = false
    @sim = new iosctrl.Simulator

  start: (url) ->
    @sim.open("#{url}?id=#{@id}").fail (err) -> throw err

  kill: (done) ->
    return done() if @sim.state is 'ready'
    @sim.close().then done, (err) -> throw err

  markCaptured: -> @captured = true
  isCaptured: -> @captured

exports["launcher:iOS"] = ['type', (id) -> new IOSLauncher id]