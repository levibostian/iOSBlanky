![Swift 5.0.x](https://img.shields.io/badge/Swift-5.0.x-orange.svg)
![XCode 10.2](https://img.shields.io/badge/XCode-10.2-grey.svg)

# iOSBlanky

Clone the repo, edit some configurations, and get off to building your next awesome iOS app!

This project is _very_ opinionated because, well, it's designed for the apps that [I](https://github.com/levibostian/) build.

Nodejs developer? I have [a boilerplate project for you!](https://github.com/levibostian/expressjsblanky)
Android developer? I have [a boilerplate project for you!](https://github.com/levibostian/androidblanky)

# What is iOSBlanky?

iOSBlanky is an iOS app. It's a simple iOS app that includes a collection of libraries, configurations, and architecture decisions for all of the apps that I build. So whenever I want to build a new iOS app, instead of creating a blank XCode project and spending a bunch of time configuring it to include all my libraries, configurations, and architecture decisions in it that I want, I simply clone this repo, do some editing to the project, and off to building my app!

# Why use iOSBlanky?

You know the feeling when you go to begin a new project. The day you begin a project is spent on just setting up your project, configuring it, and getting your environment all setup. It takes hours to days to complete!

iOSBlanky works to avoid that. By having a blank iOS app already created, you are ready to jump right into developing your new app. iOSBlanky works to get you to building your app within minutes instead of hours or days.

# What are some cool things about iOSBlanky?

iOSBlanky has been modified over years of building iOS apps. Through experience, anyone is guaranteed to find many annoyances and bugs while building apps. As I build more and more apps, when I encounter a new bug or annoyance I have with building iOS apps, I spend some engineering time to create a solution to the problem and then I put it in this repo.

iOSBlanky comes equipped with the following features:

- Swift. Yeah, swift is pretty cool. 
- Build and deploy a development, beta, and production app. This allows you to perform internal and external beta testing of your app to make sure everything works great.
- Setup with dependency injection and mocking to allow you to unit test easily. Also, dependency graph tested via unit test for missing registrations. 
- (Coming soon!) ~~When creating integration tests, it can be necessary to insert fake data into your database and then run a HTTP request against your code to test it. iOSBlanky is setup to insert fake data into your database super easily.~~
- Setup with Travis CI to build, lint, test, and deploy your apps.
- Fastlane setup for quick and easy local development as well as app deployment.
- Unit, integration, and UI testing setup.
- CoreData setup to quickly jump into database initialization. 

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
```

* Open `iOSBlanky.xcworkspace` in XCode.
* Open project settings and (1) change the team the app belongs to, (2) change target name (found in the right panel of XCode), (3) change bundle identifier. Quit XCode. 
* Open `Podfile` in a text editor. Edit the Podfile's "target" to the name of the new target name you set above ^^^. Run `pod install` again. Then, remove the old workspace file: `rm iOSBlanky.xcworkspace`. Also, delete the LICENSE file if you're writing closed source: `rm LICENSE`
* Open `.swiftlint.yml` file and edit `iOSBlanky` in `Sources` to name of your source directory.
* Open *new* XCode workspace file in XCode.
* Open project settings > General, scroll to bottom to view the list of all cocoapods frameworks you have installed in app. Delete `Pods_iOSBlanky.framework`. Quit XCode. 
* In finder, rename the `iOSBlanky` source code directory to `NameOfYourApp`. Repeat for `iOSBlankyTests` and `iOSBlankyUITests`.
* Open XCode workspace file in XCode. Along left side where you view all of the files in your project, click on the `iOSBlanky` group folder. Open the right panel of XCode and you will see a folder icon. Click this and choose the newly renamed folder you edited in the step above ^^^. Repeat this for the `iOSBlankyTests` and `iOSBlankyUITests` groups as well. Then, rename the group names in the left side panel.
* Open project settings > General in XCode again. Scroll to bottom to view the list of all cocoapods frameworks installed. Remove `Pods_NameOfYourApp.framework`, then add it back. 
* Target > General in XCode. The middle where you usually enter your bundle identifier, it will have a button asking you to locate your Info.plist file. Choose `NameOfYourApp/Info.plist`. 
* Target > Build settings in XCode. Look for "Product Bundle Identifier" and "Product Name". Change these to the values you want for identifier and name of app.
* Top left corner by the Play and Stop button. You see the schemas with name `iOSBlanky`. Click on it and go to *Manage schemas*. You can now click on `iOSBlanky` and rename it to `NameOfYourApp`. 
* Hold down option key on keyboard and click on the Play button. You can now select in the list what build version you want to run. I start with debug/dev. Go ahead and try to run on a device now. 

Done! Well, with getting your app project renamed and built. Now comes configuration of all the various tools. 

* Next, follow all of the directions below in the [services](#services) section to configuring the services this project is setup to work with.
* When you want to run the app locally on your machine for development purposes, follow the directions for [development](#development).
* If you want to run unit, integration, and UI tests for your application, check out the section for [tests](#tests).
* If you wish to deploy your app, check out the section on [deployment](#deploy).

Enjoy!

# What is included in iOSBlanky?

### Language:

- [Swift](https://swift.org/)

### Database: 

- [CoreData](https://developer.apple.com/documentation/coredata)

### Libraries:

All libraries installed via [Cocoapods](https://cocoapods.org/). 

- [SwiftLint](https://github.com/realm/SwiftLint/) - Linting tool for Swift to catch potential issues in your source code.
- [Moya](https://github.com/Moya/moya) - Easy to use networking library for HTTP requests. 
- [RxSwift/RxCocoa](https://github.com/ReactiveX/RxSwift/) - ReactiveX library for easy asynchronous programming. 
- [Swinject](https://github.com/Swinject/Swinject) - Dependency injection framework to create a dependency graph easy.
- [Firebase Analytics](https://firebase.google.com/docs/analytics) - Capture analytics to make future decisions based on user trends. 
- [Firebase RemoteConfig](https://firebase.google.com/docs/remote-config) - Dynamically change values and code in your live production app at runtime.
- [Firebase Messaging](https://firebase.google.com/docs/cloud-messaging) - Receive push notifications. 
- [Firebase DynamicLinks](https://firebase.google.com/docs/dynamic-links/) - Open up your app when user touches a certain URL on their device that's registered to your app. 
- [Firebase Performance](https://firebase.google.com/docs/perf-mon) - Track the performance of your app for issues such as network quality and UI hangs. 
- [Crashlytics](https://firebase.google.com/docs/crashlytics) - Error reporting to capture bugs that happen. 
- [Kingfisher](https://github.com/onevcat/Kingfisher) - Easily populate UIImageView with an image URL. 
- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess/) - Quick and easy keychain management. 
- [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) - Show empty view when UITableView empty. 
- [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager) - Adds default behavior for the keyboard in your app. 
- [Wendy](https://github.com/levibostian/wendy-ios/) - Build offline first iOS mobile apps. Remove loading screens, perform tasks instantly. 
- [SnapKit](https://github.com/SnapKit/snapkit/) - Create views and layouts of your app screens using code with ease. 
- [Teller](https://github.com/levibostian/teller-ios) - iOS library that manages your app's cached data with ease.
- [WoodPecker](https://github.com/appwoodpecker/woodpecker-ios) - Handy tool for development to view files, network requests/responses, and more from the development device. 

# Services 

- [Firebase](https://firebase.google.com/docs/) - Used for analytics, error reporting, remote configuration, dynamic links. 

This project is mostly setup already for Firebase. It's setup for a dev, beta, and production environment. Follow the directions below to finish setup. 

Configure:
* Create a new Firebase project for this app. 
* Create 3 separate iOS apps inside of this 1 new Firebase project. Create 1 app for the development version of the app, 1 for beta, and 1 for production. 
* You will now have 3 separate `GoogleService-Info.plist` files you can download from the Firebase website. Download the files and replace the one inside of `SourceDirectory/Assets/Google Service/`. 

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
* Edit the `.travis.yml` file. You really only need to edit the environment variables for now. 

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
* Go through all of the files in the `fastlane/` directory. You will need to edit some values in these files. The files will walk you through what to edit and what you do not need to edit. 

Fastlane is setup to run some tasks on a CI server and some tasks are run manually by yourself. 

Tasks to run manually:
* Edit the file, `fastlane/icons/icon.jpg` to be your icon to use for your app. Then run this command: `bundle exec fastlane generate_icons` to generate alll of the app icons for the app. 
* Crashlytics is setup to automatically upload dsyms for you when you build your app, but in case some go missing, you can run this command: `bundle exec fastlane refresh_dsms version:0.1.1 build_number:2222 app_id:com.foo.com` to download dsyms from Apple and upload to Crashlytics. 
* Run: `bundle exec fastlane create_apps` to create apps in your Apple Developer Account to push to them later. 
* Run: `bundle exec fastlane init_dev` to create profiles and certificates for development and production pushing. This saves to a git repo that you setup to store the files in to share with your team and CI server. 

*Note: Fastlane uses Mailgun behind the scenes for sending emails to your developer when issues go wrong and tasks are successful. Create a Mailgun account, add your domain name to the account, then set your API key in `.travis.yml` as a secret environment variable with the value `MAILGUN_DOMAIN_API_KEY`. 

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
pod install 
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
