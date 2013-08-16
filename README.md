karma-ios-launcher
==================

[Karma](http://karma-runner.github.io) launcher for the Xcode iOS Simulator.

[![NPM version](https://badge.fury.io/js/karma-ios-launcher.png)](http://badge.fury.io/js/karma-ios-launcher)

This Karma plugin adds a browser launcher for the Xcode iOS Simulator.


Requirements
------------

You must have Xcode installed as well as the iOS Simulator.


Installation
------------

Install the plugin from npm:

```sh
$ npm install karma-ios-launcher --save-dev
```

Or from Github:

```sh
$ npm install 'git+https://github.com/xdissent/karma-ios-launcher.git' --save-dev
```

Add `iOS` to the `browsers` key in your Karma configuration:

```coffee
module.exports = (config) ->
  config.set

    # Start these browsers:
    browsers = [
      'iOS'
    ]

    # ...
```


Usage
-----

Just run your tests!

```sh
$ karma start
INFO [karma]: Karma v0.9.3 server started at http://localhost:9876/
INFO [launcher]: Starting browser iOS
INFO [Mobile Safari 6.0.0 (iOS 6.1)]: Connected on socket id iDIO2uQQP4qe6dFRjn6p
Mobile Safari 6.0.0 (iOS 6.1): Executed 1 of 1 SUCCESS (0.219 secs / 0.063 secs)
TOTAL: 1 SUCCESS
```

If you'd like to see the debug output from iosctrl, set the `DEBUG` 
environment variable to `iosctrl:*`:

```sh
$ export DEBUG='iosctrl:*' # for bash
```

```sh
$ set -x DEBUG 'iosctrl:*' # for fish
```