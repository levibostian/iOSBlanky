![Swift 5.2.x](https://img.shields.io/badge/Swift-5.2.x-orange.svg)
![XCode 11.5](https://img.shields.io/badge/XCode-11.5-grey.svg)

# iOSBlanky

Boilerplate project for iOS apps. The template that [I use for the apps that I build](https://curiosityio.com/).

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
- Deployment of the app with CI server.
- Offline-first functionality through [Teller](https://github.com/levibostian/teller-ios/) and [Wendy](https://github.com/levibostian/wendy-ios/)

# What is included in iOSBlanky?

Go ahead and explore the source code! No need to include _all_ of the details here, but here is a gist of the major components of this project:

- Project uses Swift as the programming language and XCode as the editor.
- Firebase setup for push notifications and some other services such as dynamic links, analytics, crash reporting. 
- XCTest framework used for unit, integration and UI tests. On the CI server, tests are executed with Fastlane scan.
- Core Data used as the database to store user data. 
- Travis CI setup as the CI server to build, test, and deploy app. 

# Getting started

Developer tools you need:
* XCode 
* [CocoaPods](https://cocoapods.org/)
* [Fastlane](https://fastlane.tools/) for the initial setup. But, you shouldn't need it much beyond setup as it's meant to be used on the CI server as much as possible and not on your dev machine. 

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

# git hooks
./hooks/autohook.sh install
```

* Open `App.xcworkspace` in XCode.
* Open project settings and change the team the app belongs to. Quit XCode. 
* Edit `.env` with the new target name you just set as well as all of the other values such as bundle identifier and app name. 
* Run command: `./set_environment.rb`. This will rename the app, set bundle identifier, and a few other things. 
* Delete the LICENSE file if you're writing closed source: `rm LICENSE`
* Time to try and run your app! Compile it and see if it builds. 

Done! Well, with getting your app project renamed and built. Now comes configuration of all the various tools. 

Continue reading this doc to learn about next steps to do to take full advantage of this project. 

Enjoy!

# Environments 

This project assumes that you have 2 environments for your app. Production and Testing. 

Production:
* Used for the public when they download the app from the App Store. 
* Used for public beta testing through TestFlight. 

Testing:
* Used during QA testing. QA testing at this time is only for the development team. 
* Used for internal team during internal testing. This is meant for internal team to have the app on their devices to test out new features that are coming out. They can test out things that are very fresh. 

How you change to each of these environments is using the `./set_environment.sh` script. Read the top of the script to know how to use it. This script is used on the CI server for you but you may need to use if on your local computer to switch to the testing environment. 

Sure, you may also have a development environment. But that is unique to everyone. So, I recommend that you set the environment to the testing environment, then just edit the `.env` to edit things like the API endpoint to a development server. Try to keep as much as possible to the original testing environment. 

# Next steps

Beyond getting your project to build, there are many more steps to get your project working with all of the various projects and get it deployed for others to use. 

Below, you will find a todo list of tasks to complete. This list is meant to be followed in order from top to bottom as some tasks depend on other tasks. 

- [ ] Create an Apple Developer account if you have not already. Pay the annual membership fee so you get access to App Store Connect. This process takes a while to do so get this process started right away!

- [ ] Enable Travis-CI for your GitHub repository. The `.travis.yml` file is already made and fully configured for you. You should just need to [enable Travis](https://docs.travis-ci.com/user/tutorial/) and you're good to go! 

There are many environment variables within the `.travis.yml` file that you will need to set to get things like deployment working. In the steps below when we say to *set an environment variable on the CI server*, [this is what we mean](https://docs.travis-ci.com/user/environment-variables/). 

- [ ] This project uses the tool [cici](https://github.com/levibostian/cici/) to store secret files in the source code of this project. The `.cici.yml` file is already setup for you to have a testing (aka staging) environment and a production environment. 

Read up on this tool so you can use it in this project. 

- [ ] Create a new [Firebase](https://firebase.google.com/) project for your app. Once you create a project, you will be asked to add an app to the project. Go ahead and add your first iOS app into Firebase. Once you do this, Firebase will give you a `GoogleService-Info.plist` file. This file belongs in the `_secrets` directory for `cici` to organize for you. 

- [ ] ...wait until you have your Apple Developer account created fully and you have access to App Store Connect...

- [ ] Make sure you are an admin in the new Apple Developer account. You must be an admin to create apps and setup the account going forward. 

Fastlane needs to login to your Apple developer account. But, Apple requires that all accounts must use 2FA when they hold the `Account Holder` permission. To greatly simplify the process of using fastlane on a CI server, create a brand new Apple account just for CI tasks for this team.

Make sure this new Apple account *doesn't* have 2-factor authentication enabled and doesn't have the `Account Holder` role. Invite it to your Apple account and then fill in `FASTLANE_USER` and `FASTLANE_PASSWORD` environment variables on the CI server. 

- [ ] Run `fastlane create_app_online -c “Company Name”` on your local dev machine. [fastlane create_app_online](https://docs.fastlane.tools/actions/produce/) is used to create apps in your Apple Developer account. The CLI will ask you some questions to create the app. 

Do this twice. Once for your production app, another one titled "YourAppName Testing" to be a testing version of the same app. Having 2 separate apps allows your team members to have multiple apps installed on their devices. 

*Note:* If this command does not work for you, you can always create the accounts manually by logging into your Apple Developer account online. 

- [ ] In your Firebase project, go into the project settings > for each app, add the app store app ID to each app that has an entry in the App Store. 

- [ ] Next is to create certificates and provisioning profiles. There are a few steps to get this done.

  * Create a new GitHub repo (make it private) thats job is to store this information. Leave the repository blank. Set `MATCH_GIT_REPO` environment variable for the CI server. 
  * In order to create a development certificate, you must have at least 1 iOS device added to your Apple Developer account. Run `fastlane register_device` to add one. 
  * In a directory that is *not* the root directory of your project, run these commands (if you run these commands in the root directory of your project, fastlane will pick up `fastlane/Matchfile` which is meant for read-only CI access so we need to ignore that file):

  ```
  fastlane match development
  fastlane match appstore # if you're building an enterprise account app, use `enterprise` instead of `appstore`
  ```

  You will be asked for a password to encrypt the data. The command `openssl rand 60 | openssl base64 -A` works well to generate one. You need to set `MATCH_PASSWORD` environment variable with this password you created. 

  You will need to run these commands twice because you need to generate for the production app and for the testing app. 

  Note: If your certificate or profile ever becomes expired or you encounter an error when running this command such as having too many certs created, you can run `fastlane match nuke XXX` where XXX is `developerment`, `appstore`, etc. which will delete all certs and profiles for development. Then, you can run match again to re-generate a new set.

  * Now, you can open XCode > Open your project settings > Signing > and manually select the provisioning profile for each configuration (development and release). 

  * After done, everything on the CI server is ready to get the correct certificates and profiles. Everyone else on your team can run `fastlane match development` in the root directory of the project and they will be able to download the certificates/profiles you created in a read-only way. This is because the `fastlane/Matchfile` is configured to be read-only be default. 

  *Note: Match creates provisioning profiles in the form `match AppStore com.example.app`, `match Development com.example.app`, and `match InHouse com.example.app` (enterprise apps). Assuming this naming is correct, the CI server is currently setup to automatically build and sign your app for you for the App Store. [See this guide on setting provisioning profiles for `build_app` action](https://docs.fastlane.tools/codesigning/xcode-project/#xcode-9-and-up). If you're deploying an Enterprise app, edit the `fastlane/Fastfile` from `match AppStore` to `match InHouse` where you see that text. If this setup does not work, you may need to use `sigh` to download your provisioning profile from your git repo to a file on the CI server and then use `update_project_provisioning` action to set the profile based on the sigh downloaded profile file. However, let's try to not use this as it's more complex.*

- [ ] If you're going to be using push notifications in your app, see [this doc](https://firebase.google.com/docs/cloud-messaging/ios/certs#create_the_authentication_key) on how to create a new APN key. *Note: Create a APN key, not a certificate. Keys can be used by multiple environments, debug/release config, and don't expire.* Once you have that key created, you will need to see [this doc](https://firebase.google.com/docs/cloud-messaging/ios/client#upload_your_apns_authentication_key) on how to upload this new APN key to Firebase. 

Once that is setup, I recommend reading through the `AppDelegate.swift` file as it contains listeners for many FCM tasks you may want to handle. 

- [ ] If you want to use [Firebase DynamicLinks](https://firebase.google.com/docs/dynamic-links/ios) in your app, most of the code to handle DynamicLinks is already setup. However, you will need to do some steps in order to confirm everything is setup. 

* [Follow the directions](https://firebase.google.com/docs/dynamic-links/ios/receive#set-up-firebase-and-the-dynamic-links-sdk) on setting up DynamicLinks in your app. *Note: you can skip many of the steps such as adding the CocoaPods frameworks, but keep reading as it's the later steps that you need to do*
* Now, you need to follow the steps [to configure a DynamicLinks URL](https://firebase.google.com/docs/dynamic-links/ios/receive#open-dynamic-links-in-your-app) with your app. 
* Done! DynamicLinks can be tested by pasting the URL in Safari and loading the webpage. Your app can be launched from there and you can set breakpoints to debug. 

- [ ] There are more environment variables you need to set on the CI server. See what ones you have not yet filled in and fill them in. They should be self-explanatory. 

# Tests

This project is setup to create and run unit, integration, and UI tests against your code base super easily. For information on how to _write_ tests, check out the tests written in the XCode project already.

It's recommended to run tests inside of XCode using the UI. This project is also setup to run tests via Travis CI for you. 

# Deploy

_Warning: Before you try and deploy your application, make sure you have followed the instructions on how to get your CI server up and running._

Deployment is setup for you on the CI server as long as you follow all of the instructions above in the getting started guide. 

However, let's get into the deployment workflow. This project uses the tool [semantic-release](https://github.com/semantic-release/semantic-release) along with [fastlane](https://fastlane.tools/) on your CI server to deploy your app for you. 

All you need to do is make sure all of your git commit messages are written as [conventional commits](https://www.conventionalcommits.org/), make a pull request on GitHub with all of the changes you want, after the CI server shows all of your tests are passing and you have tested the app yourself to make sure it all works, merge the pull request and then semantic-release will take care of building your app and pushing it to TestFlight and the App Store for you! Note: the app will be built and pushed to TestFlight and the App Store but will *not* be submitted. You must manually go into App Store Connect and deploy the app you want. 

The CI server is setup like this:
* The power of deployments comes from pull requests on GitHub. If you make a pull request into the branch named `beta`, a new build of your app will be released with the version `X.X.X-beta.Y` where Y will be incremented. If you merge into `master` (recommended), a new build will be released to `X.X.X` semantic versioning. 
* On every pull request into GitHub, the app will be built against the testing environment and will be submitted to [Firebase app distribution]() so you, the developer, can quickly test out the app or send a demo. Make sure the app is fully working as intended. 
* When the PR is merged, the app will be built and pushed to TestFlight as well as the App Store. However, the app will *not* be submitted. It will only be pushed to Apple to process. You must manually go into the App Store Connect and deploy an app build to TestFlight or to the App Store if you want an update. This is on purpose so that (1) anyone on your team can edit the App Store details, (2) sometimes App Store Connect gets an update and fastlane breaks. Sometimes it's just easier to use the web interface. 

## Author

- Levi Bostian - [Freelance Android & iOS app development for startups](https://curiosityio.com/)

## Contribute

iOSBlanky is not open for contributions at this time. This project showcases _my_ preferred way to build an iOS app. If you wish to make edits, by all means, fork the repo and make your edits in your own copy of the repo.

I do make some exceptions for contributions. If you are wondering if your contribution is welcome, [create an issue](https://github.com/levibostian/iosblanky/issues/new) describing what you would wish to do.
