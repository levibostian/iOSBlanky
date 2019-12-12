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
### ios set_environment
```
fastlane ios set_environment
```
From a .env file, change the app's properties. It's easier to do in fastlane, so that's why we're doing it here.
### ios deploy
```
fastlane ios deploy
```

### ios generate_icons
```
fastlane ios generate_icons
```
Build and upload beta app to TestFlight

Build and upload production app to the App Store

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
