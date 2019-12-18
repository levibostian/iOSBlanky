![Swift 5.0.x](https://img.shields.io/badge/Swift-5.0.x-orange.svg)
![XCode 11.2](https://img.shields.io/badge/XCode-11.2-grey.svg)

# iOSBlanky

Boilerplate project for iOS apps. The template that [I](https://github.com/levibostian/) use for the apps that I build.

Nodejs developer? I have [a boilerplate project for you!](https://github.com/levibostian/expressjsblanky)
Android developer? I have [a boilerplate project for you!](https://github.com/levibostian/androidblanky)

# What are the goals of iOSBlanky?

iOSBlanky has been modified over years of building iOS. Through experience, you are guaranteed to find many annoyances and bugs. After each encounter, some engineering work is done to help remove that annoyance and prevent that bug from happening again.

iOSBlanky comes equipped with the following goals:

- Get up and running building an app as fast as possible. Pre-configure this project so you don't have to. Install set of dependencies and configure them assuming they will be used. 
  - Make some assumptions about what this app will probably use such as push notifications, dynamic links, Core Data, etc. If you don't need something, just delete that code. 
- Latest version of Swift and XCode. 
- Support for older versions of iOS so people can enjoy using their older hardware, for longer. 
- Full configuration of the application through environment variables as defined [in the 12factor app](https://12factor.net/config).
- Unit, integration, and UI testing.
- Easily create mocks and work with sample data in tests.
- Use a CI server to run lint, tests on each commit of the code.
- Full deployment of the app with CI server.
  - Fully automated deploy including pushing metadata and taking new screenshots for the store (thanks fastlane!). 

# Getting started

- First, clone this repo:

```
git clone https://github.com/levibostian/iOSBlanky.git NameOfYourNewApp
cd NameOfYourNewApp
rm -rf .git/
git init
git config user.email "you@example.com"
git config user.name "First Last"
git add .; git commit -m "Initial commit. Created project from levibostian/iOSBlanky boilerplate.";
pod install
bundle install
cp .env.example .env
```

* Open `iOSBlanky.xcworkspace` in XCode.
* Open project settings and (1) change the team the app belongs to, (2) change target name (found in the right panel of XCode). Quit XCode. 
* Edit `.env` with the new target name you just set as well as all of the other values such as bundle identifier and app name. 
* Run `pod install` again which will create new workspace and project files. Then, remove the old workspace file: `rm iOSBlanky.xcworkspace`.
* Run command: `./set_environment.rb`. This will rename the app, set bundle identifier, and a few other things. 
* Delete the LICENSE file if you're writing closed source: `rm LICENSE`
* Open project settings > General, scroll to bottom to view the list of all cocoapods frameworks you have installed in app. Delete `Pods_iOSBlanky.framework`. Quit XCode. 
* Open project settings > General in XCode again. Scroll to bottom to view the list of all cocoapods frameworks installed. Remove `Pods_NameOfYourApp.framework`, then add it back. (There was a bug I encountered once. Not sure if this fixes it)
* Time to try and run your app! Compile it and see if it builds. 

Done! Well, with getting your app project renamed and built. Now comes configuration of all the various tools. 

* Next, follow all of the directions below in the [services](#services) section to configuring the services this project is setup to work with.
* When you want to run the app locally on your machine for development purposes, follow the directions for [development](#development).
* If you want to run unit, integration, and UI tests for your application, check out the section for [tests](#tests).
* If you wish to deploy your app, check out the section on [deployment](#deploy).

Enjoy!

# What is included in iOSBlanky?

Go ahead and explore the source code! No need to include _all_ of the details here, but here is a gist of the major components of this project:

- Project uses Swift as the programming language and XCode as the editor.
- Firebase setup for push notifications and some other services such as dynamic links, analytics, crash reporting. 
- XCTest framework used for unit, integration and UI tests. On the CI server, tests are executed with Fastlane scan.
- Core Data used as the database to store user data. 
- Travis CI setup as the CI server to build, test, and deploy app. 

# Services 

This project uses a list of various services to receive push notifications, run a CI server, and more. To keep the code base simple, [keep the environments close](https://12factor.net/dev-prod-parity), and avoid runtime complexity/bugs, all of these services are configured with environment variables all defined with a `.env` file.

Now, let's go into each of the `.env` variables, enabling the various services as we go on.

- [Firebase](https://firebase.google.com/docs/) - Used for analytics, error reporting, remote configuration, dynamic links. 

This project is mostly setup already for Firebase. Follow the directions below to finish setup. 

Configure:
* Create a new Firebase project for this app.
* Create separate Firebase projects for each app environment, or, create 1 project and add separate apps in the 1 target for each environment. Either way, follow the directions for [here for the tool cici](https://github.com/levibostian/cici/) for how to store the `GoogleService-Info.plist` file that Firebase gives you. 

Now, here are some configuration instructions for how to get up and running fast with each of the added Firebase services. *Note: If a Firebase service is not listed below, it's already configured for you!*

#### RemoteConfig

RemoteConfig has already been added to this project. The default values .plist file has been added as well. All you need to do is...

When you want to create a new key/value remote config pair, you need to:
1. Check out the `FirebaseRemoteConfigDefaults.plist` and `RemoteConfig.swift` files to add the new key/value pair. 
2. Add the key/value pair to the Firebase Dashboard for your project. 

#### Messaging

To send and recieve push notifications in your app, FCM requires that you register an APN key with Firebase from your Apple Developer Account. This is a key that does not expire.
* See [this section](https://firebase.google.com/docs/cloud-messaging/ios/certs#create_the_authentication_key) in the Firebase docs on how to create a new APN key. 
* Once you have that key created, you will need to see [this section](https://firebase.google.com/docs/cloud-messaging/ios/client#upload_your_apns_authentication_key) in the Firebase docs on how to upload this new APN key to Firebase. 

Once that is setup, I recommend reading through the `AppDelegate.swift` file as it contains listeners for many FCM tasks you may want to handle. 

#### DynamicLinks

Most of the code to handle DynamicLinks is already setup. However, you will need to do some steps in order to confirm everything is setup. 
* [Follow the directions](https://firebase.google.com/docs/dynamic-links/ios/receive#set-up-firebase-and-the-dynamic-links-sdk) on setting up DynamicLinks in your app. *Note: you can skip many of the steps such as adding the CocoaPods frameworks, but keep reading as it's the later steps that you need to do*
* Now, you need to follow the steps [to configure a DynamicLinks URL](https://firebase.google.com/docs/dynamic-links/ios/receive#open-dynamic-links-in-your-app) with your app. 
* Done! DynamicLinks can be tested by pasting the URL in Safari and loading the webpage. Your app can be launched from there and you can set breakpoints to debug. 

- [Travis CI](https://travis-ci.com/) - CI server to run tests, build iOS app, and deploy apps to TestFlight and the App Store.

Configure:
* Create a [Travis](https://travis-ci.com/) account, and enable your GitHub repo for your API project in your Travis profile page.
* In the `.travis.yml` file, you will see some secret environment variables you need to define in the travis project. 
* Then, go into your travis project settings and create a cronjob, daily, on the master branch. This will enable some fastlane tasks to run daily for up-keep. 

I have setup the CI server workflow to work as follows:

Bug fixes, feature additions, and other code changes:

- Create a new git branch for the changes.
- Make a pull request into the `master` branch. Make sure that travis successfully runs all of your tests.

When the `master` branch is ready for a release:

- Create a new branch off of `master` with the name of your release (example: `0.2.1`). 
- Run `ruby Dangerfile` from your local machine to view the instructions on the code changes you need to do to make a deployment. 
- Merge your branch into `master` via pull request. 
- Make a new git tag off of `master`. Beta releases have the git tag form: `0.2.1-beta` where production have form `0.2.1`. 
- Push the new git tag to GitHub via `git push --tags`. 

- [Danger](http://danger.systems/ruby/) - Bot that looks over pull requests and makes sure you do not forget to complete certain tasks.

Configure:   
* We are assuming you have already done the instructions for setting up Travis. 
* Setting up Danger is super easy. The `Dangerfile` is already created for you. You just need to create a GitHub account used as a bot and then add an access token to Travis as an environment variable. [Here are instructions](http://danger.systems/guides/getting_started.html#creating-a-bot-account-for-danger-to-use) for generating a token. Keep in mind if you are making this an open or closed source repository. 

- [Fastlane](https://fastlane.tools/) - Automate the building, signing, and releasing of your app. 

Configure:
* We are assuming you have already done the instructions for setting up Travis. 
* Edit the `fastlane/Deliverfile` values for your app. Also, edit the `fastlane/metadata/` directory of files for your app. 

After you create your app ID in your developer account online, you will now want to run `bundle exec fastlane match` and `bundle exec fastlane match --development` on your local machine in order to get your certificates and profiles generated. 

# Development

_Warning: Make sure to follow the [getting started](#getting-started) section to configure your project before you try and run it locally._

Do you wish to build and run this iOS app locally on your machine for development? Let's do it.

Developer tools you need:
* XCode 
* [Ruby](https://github.com/rbenv/rbenv) (you can run `rbenv install` and it will install the ruby version set for this repo)
* [Bundler](https://bundler.io)
* [CocoaPods](https://cocoapods.org/)

```bash
bundle install 
./hooks/autohook.sh install
pod install 
bundle exec fastlane match appstore
bundle exec fastlane match development # Can be: appstore, adhoc, enterprise or development
```

Now, open up your workspace file in XCode. 

# Tests

This project is setup to create and run unit, integration, and UI tests against your code base super easily. For information on how to _write_ tests, check out the tests written in the XCode project already.

It's recommended to run tests inside of XCode using the UI. This project is also setup to run tests via Travis CI for you. 

# Deploy

_Warning: Before you try and deploy your application, you need to follow the directions on getting your [development](#development) environment setup and the application running locally. Also, recommended [your tests](#testing) run and pass._

Deployment is easy. As long as you have an Apple Developer account and have followed the directions thus far to get Travis CI running and Fastlane setup, you're done. Follow the directions for Fastlane in this doc and you will be all setup. Beta deployments on TestFlight and production deployments on the App Store are done for you via Travis CI. 

## Author

- Levi Bostian - [GitHub](https://github.com/levibostian), [Twitter](https://twitter.com/levibostian), [Website/blog](http://levibostian.com)

![Levi Bostian image](https://gravatar.com/avatar/22355580305146b21508c74ff6b44bc5?s=250)

## Contribute

iOSBlanky is not open for contributions at this time. This project showcases _my_ preferred way to build an iOS app. If you wish to make edits, by all means, fork the repo and make your edits in your own copy of the repo.

I do make some exceptions for contributions. If you are wondering if your contribution is welcome, [create an issue](https://github.com/levibostian/iosblanky/issues/new) describing what you would wish to do.
