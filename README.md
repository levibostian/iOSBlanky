![Swift 5.3.x](https://img.shields.io/badge/Swift-5.3.x-orange.svg)
![XCode 12](https://img.shields.io/badge/XCode-12-grey.svg)

# iOSBlanky

Boilerplate project for iOS apps. The template that [I use for the apps that I build](https://curiosityio.com/).

Nodejs developer? I have [a boilerplate project for you!](https://github.com/levibostian/expressjsblanky)
Android developer? I have [a boilerplate project for you!](https://github.com/levibostian/androidblanky)

# Overview of project

### What are the goals of iOSBlanky?

iOSBlanky has been modified over years of building Android apps. Through experience, I try to improve the way that I build iOS apps as I encounter common bugs and annoyances. After each encounter, some engineering work is done to help remove that annoyance and prevent that bug from happening again.

iOSBlanky comes equipped with the following goals:

- Get up and running building an app as fast as possible. This project is very opinionated. Development tools and iOS libraries have already been installed and setup for you. This allows you to get up and running, fast. If you don't need a feature added to the boilerplate, just delete that code.   
- Latest version of Swift and XCode. Support for older versions of iOS so people can enjoy using their older hardware, for longer.
- Full configuration of the application through environment variables as defined [in the 12factor app](https://12factor.net/config).
- Unit, integration, and UI testing.
- Leverage a CI server to run tests, build the app, and deploy it. 

### Services 

When I build apps, I like to use some external development services/tools to improve my developer experience and user experience. Here is a list of these services:

* [Travis CI](https://travis-ci.com/) - CI server provider. 
* [Firebase](https://firebase.google.com/) - Provides a few pieces of functionality to the app. 
  * [Crash reporting](https://firebase.google.com/products/crashlytics) - When the app crashes at runtime, we get notified so we can fix the issue. We get notified when crashes happen automatically.
  * [Performance monitoring](https://firebase.google.com/products/performance) - Finds places in your code where the app is slow. When the network is slow or when you are slowing down the UI thread of the app. 
  * [Test lab](https://firebase.google.com/products/test-lab) - Run UI or integration tests on a real device in the cloud. Running tests on an actual device is much easier and faster then alternatives such as running them on an emulator instance running on the CI server. The CI server communicates with Test Lab for you. 
  * [App distribution](https://firebase.google.com/products/app-distribution) - Allows people on your team to install builds of the app on their devices. This is used for QA testing of the app before we send it out to beta users. App distribution is not good for running public beta tests. It's great for using in your internal team. 
  * [Remote config](https://firebase.google.com/products/remote-config) - Allows us to make changes to the behavior of our app without needing to deploy a new version to the app store. We mostly use this service to change the text shown in the app. You can even run A/B tests on remote config values which allows you to A/B test colors, text, or features of your app. 
  * [Push notifications](https://firebase.google.com/products/cloud-messaging) - Send push notifications to the app users. You can manually send push notifications for marketing purposes using the Firebase website. We also may send automated push notifications from the API. We can send push notifications to specific devices, all devices for a user, or to groups of users at once. 
  * [Analytics](https://firebase.google.com/products/analytics) - Analytics to track user activity within our app. Allows us to see how the users are using our app so we can make changes in the future based off of user usage. 
  * [Dynamic links](https://firebase.google.com/products/dynamic-links) - When the user of our app opens a URL for our website, we can have our app open instead of having the URL open in the browser on the device. This is how we perform login to an account in our app. You enter your email address into the app, the API sends you a unique URL, you open the URL on your device and we automatically log you into the app when the app opens from the URL. 

### Tools 

Below is a list of development tools that are used in this project. These are tools beyond the typical iOS development tools that are common amongst iOS developers such as XCode. Check out the `Podfile` file to see what iOS specific tools and libraries are installed in the app. 

* [cici](https://github.com/levibostian/cici/) - Used to securely store secret files within the source code repository. If you have files in your project that contain secret passwords or API keys, use cici to store those files in your code base. Do not commit these secret files into your source code repository! cici is a great way to store your upload keystore files, share secrets with your development team, white label your app, prepare for your app environments (staging, QA, beta, production builds of your app). 
* [fastlane](https://fastlane.tools/ - Tool used by the CI server to run tests and deploy the app, easily. 
* [semantic-release](https://github.com/semantic-release/semantic-release) - Tool used by the CI server to automatically deploy the app. All you need to do is follow a specific workflow in GitHub and the app will automatically deploy for you! See the [section in this doc on workflow](#workflow) to learn how to do this.

### Documentation

Besides this document, there are many more documents provided in this project to help you better understand how this project works, the decisions made in this project, and how you can use this project. Begin reading the detailed documentation [here](docs/README.md).

# Getting started

Follow the instructions below to get the code compiling on your machine so you can begin development!

**But wait!...** If you are here looking to *build a brand new app*, follow the instructions in [this document](docs/SETUP.md) to do some initial setup of the project. If someone else on your development team has already setup the project for you, you can skip reading that document and proceed with the instructions below. 

After you clone the GitHub repository on your computer, follow these instructions:

* First, you need to install some development tools on your machine. 

1. [bundler](https://bundler.io/) - Run `gem install bundler` to install it on your computer. (`gem` is a tool that is installed on your machine after you install the Ruby programming language. macOS machines already have Ruby installed by default). You know you have bundler installed when you run `bundle -v` on your computer and get an output like this: `Bundler version X.X.X`
2. [pre-commit](https://pre-commit.com/) used for git hooks. Run `brew install pre-commit` on macOS to install. See [this doc](https://pre-commit.com/#install) to install on any other OS. You know you have it installed when you run `pre-commit --version` on your computer and get an output like this: `pre-commit X.X.X`
3. [swiftlint](https://github.com/realm/SwiftLint) used for linting Swift code. Run `brew install swiftlint` on macOS to install ([other install methods](https://github.com/realm/SwiftLint#installation)). You know you have it installed when you run `swiftlint version` on your computer and get an output like this: `X.X.X`
4. [cici](https://github.com/levibostian/cici/#getting-started) used to store secret files in your source code. Run `gem install cici` to install on your computer. 
5. [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) used to format the Swift code. Run `brew install swiftformat` to install ([other install methods](https://github.com/nicklockwood/SwiftFormat#command-line-tool)). You know you have it installed when you run `swiftformat --version` on your computer and get an output like this: `X.X.X`
6. [Sourcery](https://github.com/krzysztofzablocki/Sourcery) generate boilerplate Swift code for your project. Run `brew install sourcery` to install ([other install methods](https://github.com/krzysztofzablocki/Sourcery#installation)). You know you have it installed when you run `sourcery --version` on your computer and get an output like this: `X.X.X`
7. [Cocoapods](https://cocoapods.org/) - Run `gem install cocoapods` to install it on your computer. Cocoapods installs iOS libraries for us to use in our app. 

* Next, run these commands on your machine. 

```
bundle install               # Install development tools 
pod install                  # Install dependencies 
./hooks/autohook.sh install  # Install git hooks
cici decrypt                 # When running this command, it will ask you for a KEY and IV value. Your team members should have shared these passwords with you. Enter those at that time. 
```

* Open XCode. Select `Open a project or file`. Then, select `App.xcworkspace` from the root directory of this project on your computer. 

* You're all set! Compile the app within XCode. You can also execute unit, integration, and UI tests within XCode. [This document](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/05-running_tests.html) tells you how to run tests within XCode. 

# Workflow 

This project is setup to follow a strict development workflow. This workflow when followed will automatically (1) run all of your tests to make sure they are all passing, (2) build and deploy your app for easy QA testing, (3) build and deploy your app for the app store. All of this is done for you! All you need to do is write code! 

There are some rules that you must follow for the workflow to work:
1. Never make a commit to the branches: `master`, `beta`, or `alpha`. These branches can only be updated by making a GitHub pull request into these branches. If you make a mistake and make a commit on one of these branches, [follow these instructions](https://stackoverflow.com/a/1628584/1486374) to move your commits to another branch. 
2. When you make a commit, **the commit message that you write must be written in a special way**. Read [this document](https://gist.github.com/levibostian/71afa00ddc69688afebb215faab48fd7) which explains what I mean by that. 

With those rules out of the way, let's go over the workflow for you to follow when you write code. 

Let's say that you want to make a change to the code. Any change, it does not matter (add feature, fix bug). Follow these steps:
1. Make a new git branch. Name this branch something that is not `master`, `beta`, or `alpha` as those names are reserved for special purposes. 
2. Make your code changes. Make commits on this branch. 
3. When you are done with all of your changes you want to make, [create a GitHub pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request). When you create your pull request, merge your branch into one of these branches:

* `master` - Choose this option when your change is "production ready" and ready to go to the public. If you making a small change to your app, this is a good choice to choose. You will probably choose this option most of the time. 
* `beta` - Your change is not yet ready for production. Let's say that you and your team are preparing for a big change to your mobile app that will take 2 to 3 weeks to finish. This big change might require 10 separate pull requests to finish. This branch should be used for that purpose. Merge all 10 of the separate pull requests into the `beta` branch. When all 10 of your team's pull requests are merged in and the big change to your app is done, make a new pull request from the `beta` branch into the `master` branch to make the public release. This branch is used less often then `master`, but can still come in handy every so often. 
* `alpha` - This branch is not used very often. It's mostly used for very early progress to an app. Maybe you and your team are making drastic changes to your mobile app but it's still early on in the project, use this branch. This branch is like the `beta` branch, but meant for code that is more conceptual, unstable, or could dramatically change. 

When you make a pull request, the CI server will automatically build your app and deploy the app to [Firebase App Distribution](https://firebase.google.com/docs/app-distribution). App Distribution allows you and your team members to easily install the app build on real devices to test it out. This makes QA testing (Quality assurance (QA) is a way of preventing mistakes and defects in manufactured products and avoiding problems when delivering products or services to customers) on your team super easy. Your team members do not need to download your changes to their development machine and compile the app to test it out. The CI server will make a comment giving you information about the deployed app to App Distribution. All you need to do is open the App Distribution app on your test device, install the build you want, then run the app. 

4. After you make your pull request, do not merge it until [the status checks](https://docs.github.com/en/github/administering-a-repository/about-required-status-checks) have passed. 

If you are on a software team that performs code reviews, you may need to also wait until someone from your team reads over your code and [submits a code review](https://docs.github.com/en/enterprise/2.13/user/articles/approving-a-pull-request-with-required-reviews). 

After you QA test the app, all status checks pass, and your code review has been completed, merge the pull request! 

5. After the code is merged you are all done for now. The CI server is going to automatically deploy your app for you! 

> Note: The CI server can always fail when it's trying to deploy your app. You know the deployment was successful if you see a comment on your pull request [similar to this one](https://github.com/levibostian/Swapper-iOS/pull/20#issuecomment-676499660). It may take a while for this comment to show up. Check the CI server logs if the task fails so you can fix it. 

6. The CI server will *only build your app and send it to the app store for you*. It will *not* automatically make it available to the public. That is a manual step that you need to do. Use [App Store Connect](https://appstoreconnect.apple.com/login) to publish the app to TestFlight or the App Store. The CI server only sends *builds* to Apple for processing. 

There are ways to make the CI server automatically deploy your app for you instead of requiring you to login. However, it has been decided to make it manual because...
* Future proof - If Apple makes a change in the future that breaks your CI server build and deploy process, you need to make a deployment manually anyway. 
* Reminder to update metadata - Manually deploying your app gives you the opportunity to inspect the metadata and screenshots of your app store page before you deploy it. This gives you the chance to make changes before it's live. 
* Flexibility - When a build of the app is sent to the app store, you get to choose who to deploy it to and when. Run a TestFlight internal test, TestFlight public beta test, or launch to production with a couple clicks of a button for every build that we send to Apple for processing. 

It's recommended that you follow this deployment process:
* The CI server builds and sends your app to Apple for processing after you merge a pull request. 
* Login to App Store Connect and make a release of the app to TestFlight public beta. Run this beta test for however long you feel is necessary. Watch app analytics and crash reporting to make a judgement if the build of the app is stable. 
  * If you determine the app is not stable, follow the workflow above to fix the issues and make a new public beta release. 
  * If the app is determined stable, log into App Store Connect and make a new public release of the build you pushed to TestFlight.

This deployment process is handy because it only requires 1 single build of your app. You are then able to test and deploy that 1 build however you please through the process. If you find that a build has a bug some other fix needs to happen, then that version of your software is simply flawed and you need to make a new version. 

### Generate screenshots

Need to take screenshots of the app for the app store? Screenshots are generated automatically for you through UI tests. To create screenshots, do the following steps:

* All UI tests inside of the "Screenshots" target in XCode are meant for screenshots. 
* Run `bundle exec fastlane take_screenshots` on your local development machine. 

At this time, screenshots are meant to be created on your development machine and manually upload screenshots to App Store Connect. 

## Author

* Levi Bostian - [GitHub](https://github.com/levibostian), [Website/blog](http://levibostian.com)

![Levi Bostian image](https://gravatar.com/avatar/22355580305146b21508c74ff6b44bc5?s=250)

## Contribute

iOSBlanky is not open for contributions at this time. This project showcases *my* preferred way to build an Android app. If you wish to make edits, by all means, fork the repo and make your edits in your own copy of the repo.

