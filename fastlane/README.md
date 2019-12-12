fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios refresh_dsyms
```
fastlane ios refresh_dsyms
```
Downloads dsym files from iTunes Connect (from processed builds by Apple) and uploads them to Crashlytics for reports.
### ios create_app
```
fastlane ios create_app
```

### ios deploy
```
fastlane ios deploy
```

### ios beta_build_release
```
fastlane ios beta_build_release
```
Build and upload beta app to TestFlight
### ios prod_build_release
```
fastlane ios prod_build_release
```
Build and upload production app to the App Store
### ios generate_icons
```
fastlane ios generate_icons
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
