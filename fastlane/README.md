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
### ios unit_test
```
fastlane ios unit_test
```
Run unit/integration tests
### ios ui_test
```
fastlane ios ui_test
```
Run UI tests
### ios take_screenshots
```
fastlane ios take_screenshots
```
Take screenshots for the store
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
### ios qa_deploy
```
fastlane ios qa_deploy
```
Deploy a QA (testing) build for QA.
### ios deploy
```
fastlane ios deploy
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
