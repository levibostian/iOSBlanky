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
Manually download dsym files from iTunes Connect/TestFlight (from processed builds by Apple) and uploads them to Crashlytics for reports.
### ios create_apps
```
fastlane ios create_apps
```
Create apps in iTunes Connect and developer account
### ios init_dev
```
fastlane ios init_dev
```
Setup computer for development
### ios maintenance
```
fastlane ios maintenance
```
Tasks to maintain the app after launch.
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
