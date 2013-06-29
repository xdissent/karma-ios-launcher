karma-ios-launcher
==================

[Karma](http://karma-runner.github.io) launcher for the Xcode iOS Simulator.

[![NPM version](https://badge.fury.io/js/karma-ios-launcher.png)](http://badge.fury.io/js/karma-ios-launcher)

This Karma plugin adds a browser launcher for the Xcode iOS Simulator.


Requirements
------------

This module currently requires the `canary` version of Karma:

```sh
$ npm install 'karma@canary' --save-dev
```

Note that the Karma configuration file format has changed since `v0.8`. Use 
`karma init` to generate a fresh config.

You must also have Xcode installed as well as the iOS Simulator.


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
module.exports = (karma) ->
  karma.configure

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
```

If you'd like to see the debug output from iosctrl, set the `DEBUG` 
environment variable to `iosctrl:*`:

```sh
$ export DEBUG='iosctrl:*' # for bash
```

```sh
$ set -x DEBUG 'iosctrl:*' # for fish
```