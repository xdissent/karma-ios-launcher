# # index

path = require 'path'
child_process = require 'child_process'
fs = require 'fs-extra'
Q = require 'q'
iosctrl = require 'iosctrl'

qexists = (path) ->
  deferred = Q.defer()
  fs.exists path, deferred.resolve
  deferred.promise

class IOSLauncher
  constructor: (@id, @config={}) ->
    return new IOSLauncher arguments... unless @ instanceof IOSLauncher
    @name = 'iOS'
    @captured = false

  availableSDKs: ->
    deferred = Q.defer()
    cmd = "xcodebuild -showsdks | grep iphonesimulator | " +
      "sed 's/.*\\([0-9]\\.[0-9]\\).*/\\1/'"
    child = child_process.exec cmd, (err, stdout) =>
      return deferred.reject err if err?
      deferred.resolve stdout.trim().split '\n'
    deferred.promise

  configureSDK: ->
    return @() if @config.sdk?
    @availableSDKs().then (sdks) => @config.sdk ?= sdks[sdks.length - 1]

  start: (url) ->
    @configureSDK().then =>
      return @_start url, @safariOriginalPath() if 7 > parseFloat @config.sdk
      @chownOriginalSafariParent().then => @backupSafari().then =>
        @removeSafari().then => @_start url, @safariBackupPath()
    , (err) -> throw err

  _start: (url, app) ->
    config = app: app, args: ['-u', "#{url}?id=#{@id}"]
    config.family = @config.family if @config.family?
    config.sdk = @config.sdk if @config.sdk 
    @sim = iosctrl config
    @sim.start()

  chownOriginalSafariParent: ->
    Q.nfcall(fs.stat, path.dirname @safariOriginalPath()).then (stats) =>
      return if stats.mode.toString(8)[2..] is '777'
      @privileged "chmod a+rw '#{path.dirname @safariOriginalPath()}'"

  removeSafari: ->
    qexists(@safariOriginalPath()).then (exists) =>
      return unless exists
      Q.nfcall fs.remove, @safariOriginalPath()

  backupSafari: ->
    qexists(@safariBackupPath()).then (exists) =>
      return if exists
      Q.nfcall(fs.mkdirs, path.dirname @safariBackupPath()).then =>
        Q.nfcall fs.copy, @safariOriginalPath(), @safariBackupPath()

  restoreSafari: ->
    qexists(@safariOriginalPath()).then (exists) =>
      return if exists
      Q.nfcall fs.copy, @safariBackupPath(), @safariOriginalPath()

  privileged: (sh) ->
    deferred = Q.defer()
    child = child_process.spawn 'osascript',
      ['-e', "do shell script \"#{sh}\" with administrator privileges"]
    child.on 'exit', (code, signal) ->
      return deferred.reject code unless code is 0
      deferred.resolve code
    deferred.promise

  safariBackupPath: ->
    path.join process.env.HOME, '.karma-ios-launcher', @config.sdk,
      'MobileSafari.app'

  safariOriginalPath: ->
    "/Applications/Xcode.app/Contents/Developer/Platforms/" +
      "iPhoneSimulator.platform/Developer/SDKs/" +
      "iPhoneSimulator#{@config.sdk}.sdk/Applications/MobileSafari.app"

  kill: (done) ->
    return done() if @sim.state is 'ready'
    @sim.stop().then =>
      @restoreSafari().then done
    , (err) -> throw err

  markCaptured: -> @captured = true
  isCaptured: -> @captured

IOSLauncher.$inject = ['id', 'args']

exports["launcher:iOS"] = ['type', IOSLauncher]