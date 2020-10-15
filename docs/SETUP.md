# Setup

This document is meant to be a document you only need to use one time. It's the document that you use to take the [iOSBlanky](https://github.com/levibostian/iosblanky/) project and turn it into your own project. 

Follow the instructions below. 

* Run these commands

```
git clone https://github.com/levibostian/iOSBlanky.git NameOfYourNewApp
cd NameOfYourNewApp
rm -rf .git/
git init
git config user.email "you@example.com"
git config user.name "First Last"
git add .; git commit -m "Initial commit. Created project from levibostian/iOSBlanky boilerplate.";
bundle install
pod install
```

* Lastly, to get the app to compile you need to create some files that are hidden by default because they may contain sensitive information.

```
cp .env.example .env
cp Src/GoogleService-Info.plist.example Src/GoogleService-Info.plist
```

> This project uses [cici](https://github.com/levibostian/cici/) to maintain sensitive information. Check out the project to learn how to use it.

* Delete the LICENSE file if you're writing closed source: `rm LICENSE`
* Go into `README.md` and delete the following sections:
  * Contribute
  * What are the goals of iOSBlanky?
  * The very top of the file where you see the name *iOSBlanky* and a few other sentences saying the project is boilerplate, delete all of that and rename it to the name of your app. 

You can keep the rest of the docs the way they are. They are written in a way that future developers of your project can read it and be able to get up and running. 

# Environments 

This project assumes that you have 2 environments for your app. Production and Testing. 

Production:
* Used for the public when they download the app from the App Store. 
* Used for public beta testing through TestFlight. 

Testing:
* Used during QA testing. QA testing at this time is only for the development team. 
* Used for internal team during internal testing. This is meant for internal team to have the app on their devices to test out new features that are coming out. They can test out things that are very fresh. 

Environments are maintained using the CLI tool `cici`. See document [Env](ENV.md) to learn more about environments. 

How you switch between each of these environments is using the `./set_environment.sh` script. Read the top of the script to know how to use it. This script is used on the CI server for you to build and deploy to the app store. 

What you need to do during setup is to get your testing and production environments setup so your team can get to developing on their local machines and the CI server can build and deploy for you. 

Edit the `.env` files in the `_secrets` directory. Change the values inside to values for your project. You want to `_secrets/_production` is where the production values are stored. `_secrets/_ci_` are files specific to the CI server. The files in the root of `_secrets` are for testing. These are values that you want your QA team and your developers to be using on their local machines. 

After you edit these files, use `cici` to encrypt these secrets. 

Run command: `./set_environment.rb`. This will rename the app, set bundle identifier, and a few other things.

* Time to try and run your app! 

Open `App.xcworkspace` in XCode. 

Open the project settings and change the team the app belongs to. Compile the app in XCode and see if it builds. 

Done! Well, with getting your app project renamed and built. Now comes configuration of all the various tools.

Continue reading this doc to learn about next steps to do to take full advantage of this project.

# Next steps

Beyond getting your project to build, there are many more steps to get your project working with all of the various projects and get it deployed for others to use. 

Below, you will find a todo list of tasks to complete. This list is meant to be followed in order from top to bottom as some tasks depend on other tasks. 

- [ ] Create an Apple Developer account if you have not already. Pay the annual membership fee so you get access to App Store Connect. This process takes a while to do so get this process started right away! You can't do much else until the account is created so go do that now. 

- [ ] Enable Travis-CI for your GitHub repository. The `.travis.yml` file is already made and fully configured for you. You should just need to [enable Travis](https://docs.travis-ci.com/user/tutorial/) and you're good to go! 

> Note: There are many environment variables within the `.travis.yml` file that you will need to set to get things like deployment working. In the steps below when we say to *set an environment variable on the CI server*, [this is what we mean](https://docs.travis-ci.com/user/environment-variables/). 

- [ ] Create a new [Firebase](https://firebase.google.com/) project for your app. Once you create a project, you will be asked to add an app to the project. Go ahead and add your first iOS app into Firebase. Once you do this, Firebase will give you a `GoogleService-Info.plist` file. This file belongs in the `_secrets` directory for `cici` to organize for you (remember to encrypt with cici after you edit any files in the `_secrets` directory!). 

- [ ] In your Firebase project, go into the project settings > for each app, add the app store app ID to each app that has an entry in the App Store. 

- [ ] If you want to use [Firebase DynamicLinks](https://firebase.google.com/docs/dynamic-links/ios) in your app, most of the code to handle DynamicLinks is already setup. However, you will need to do some steps in order to confirm everything is setup. 

* [Follow the directions](https://firebase.google.com/docs/dynamic-links/ios/receive#set-up-firebase-and-the-dynamic-links-sdk) on setting up DynamicLinks in your app. *Note: you can skip many of the steps such as adding the CocoaPods frameworks, but keep reading as it's the later steps that you need to do*
* Now, you need to follow the steps [to configure a DynamicLinks URL](https://firebase.google.com/docs/dynamic-links/ios/receive#open-dynamic-links-in-your-app) with your app. 
* Done! DynamicLinks can be tested by pasting the URL in Safari and loading the webpage. Your app can be launched from there and you can set breakpoints to debug. 

- [ ] Go into Firebase App Distribution and create a new group named "qa_team". Add some tester email addresses to this group for your QA team. 

- [ ] Now to setup running UI tests inside of Firebase Test Lab. 

We are using [this fastlane plugin](https://github.com/fastlane/fastlane-plugin-firebase_test_lab) to run tests in test lab. 

* You need to create a Service Account on Google Cloud to authenticate into your Google Cloud project. To do this, Firebase project > Settings > Service accounts > Click on "X service accounts from Google Cloud Platform. It opens up Google Cloud Platform webpage for you. Your Firebase project should be selected as the Google Cloud project when this webpage is opened. This is because when you have a Firebase project, a Google Cloud project gets created for you without you even knowing it. 
* If you have not already created a service account *just for firebase test lab* then let's create one. Click "Create service account" > for the name enter "firebase test lab" > for roles/permissions select "Project - Editor" > Create. 
* Once you created the service account you need to then create a key file for this account to authenticate with this service account. Do this by clicking "Add key" > JSON under the service account you just created. You will then download this .json file after it's created. Put this file in `_secrets/_ci/Src/FirebaseTestLab-ServiceAccount.json` and encrypt the secrets with cici. 

> Tip: You can store the secret in another place. You will need to edit the cici config file and edit the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to the new path. 

* ([Reference](https://github.com/fastlane/fastlane-plugin-firebase_test_lab#enable-relevant-google-apis)) Now you need to enable APIs in your Google Cloud account. [Go here](https://console.cloud.google.com/apis/library) and enable these APIs: `Cloud Testing API`, `Cloud Tool Results API`. 
* You need to now tell Firebase what device you want to run tests against. Install `gcloud` CLI on your machine with `brew cask install google-cloud-sdk`. Then run `gcloud beta firebase test ios models list` to get a table list of all the devices you have available for you. 
* Set `FIREBASE_PROJECT_ID` on your CI server and you're ready to go! `fastlane ui_test` is all setup for you in the Fastfile. 

- [ ] There are more environment variables you need to set on the CI server. See what ones you have not yet filled in and fill them in. They should be self-explanatory.

- [ ] ...wait until you have your Apple Developer account created fully and you have access to App Store Connect...

- [ ] Run `bundle exec fastlane run create_app_online` on your local dev machine. [fastlane create_app_online](https://docs.fastlane.tools/actions/produce/) is used to create apps in your Apple Developer account. The CLI will ask you some questions to create the app. 

Do this twice. Once for your production app, another one titled "YourAppName Testing" to be a testing version of the same app. Having 2 separate apps allows your team members to have multiple apps installed on their devices. 

*Note:* If asked for a SKU, just give the bundle identifier for the app. 

*Note:* If there is an error saying that that the name of your app is already taken, you have two options. 1. Use the legal form from Apple to try and get that name. Only works if you have a trademark. Or, choose a different name. I use the strategy of adding on a word to the end that describes your app. Example: If you are creating a mental health app called Your Circle and the app name Your Circle is already taken, use "Your Circle support" as the app name. 

*Note:* If this command does not work for you, you can always create the accounts manually by logging into your Apple Developer account online. 

- [ ] Make sure you are an admin in the new Apple Developer account. You must be an admin to create apps and setup the account going forward. 

Fastlane needs to login to your Apple developer account. But, Apple requires that all accounts must use 2FA when they hold the `Account Holder` permission. To greatly simplify the process of using fastlane on a CI server, create a brand new Apple account just for CI tasks for this team. Give the account the "App Manager" role in permissions. They need to be able to push to the app store, edit metadata, edit certs/profiles, and some more so developer permission or marketing is not enough. 

Make sure this new Apple account *doesn't* have 2-factor authentication enabled and doesn't have the `Account Holder` role. Invite it to your Apple account and then fill in `FASTLANE_USER` and `FASTLANE_PASSWORD` environment variables on the CI server. 

- [ ] Next is to create certificates and provisioning profiles. There are a few steps to get this done.

  * Create a new GitHub repo (make it private) thats job is to store this information. Leave the repository blank. Set `MATCH_GIT_REPO` environment variable for the CI server. 
  * In order to create a development certificate, you must have at least 1 iOS device added to your Apple Developer account. Run `fastlane run register_device` to add one. 
  * In a directory that is *not* the root directory of your project, run these commands (if you run these commands in the root directory of your project, fastlane will pick up `fastlane/Matchfile` which is meant for read-only CI access so we need to ignore that file):
  * Close XCode. I found that if XCode is open when you're done running the commands below, it will give you errors saying that the certificate is not found or is not installed on your computer. But if you close XCode and re-open it, the certificate issue will be gone. 

  ```
  fastlane match development
  fastlane match appstore # if you're building an enterprise account app, use `enterprise` instead of `appstore`
  ```

  > Tip: If you find that you cannot get match to generate certs or profiles for you, you can create them manually on the Apple Developer account website and then use [match import](https://docs.fastlane.tools/actions/match/#import) to manually import the certificate and profile. You will need to open up Keychain Access on your Mac to export the private key to the certificate. 

  You will be asked for a password to encrypt the data. The command `openssl rand 60 | openssl base64 -A` works well to generate one. You need to set `MATCH_PASSWORD` environment variable with this password you created. 

  You will need to run these commands twice because you need to generate for the production app and for the testing app. 

  Note: If your certificate or profile ever becomes expired or you encounter an error when running this command such as having too many certs created, you can run `fastlane match nuke XXX` where XXX is `development`, `appstore`, etc. which will delete all certs and profiles for development. Then, you can run match again to re-generate a new set.

  * Now, you can open XCode > Open your project settings > Signing > and manually select the provisioning profile for each configuration (development and release). 

  * After done, everything on the CI server is ready to get the correct certificates and profiles. Everyone else on your team can run `fastlane match development` in the root directory of the project and they will be able to download the certificates/profiles you created in a read-only way. This is because the `fastlane/Matchfile` is configured to be read-only be default. 

  *Note: Match creates provisioning profiles in the form `match AppStore com.example.app`, `match Development com.example.app`, and `match InHouse com.example.app` (enterprise apps). Assuming this naming is correct, the CI server is currently setup to automatically build and sign your app for you for the App Store. [See this guide on setting provisioning profiles for `build_app` action](https://docs.fastlane.tools/codesigning/xcode-project/#xcode-9-and-up). If you're deploying an Enterprise app, edit the `fastlane/Fastfile` from `match AppStore` to `match InHouse` where you see that text. If this setup does not work, you may need to use `sigh` to download your provisioning profile from your git repo to a file on the CI server and then use `update_project_provisioning` action to set the profile based on the sigh downloaded profile file. However, let's try to not use this as it's more complex.*

- [ ] If you're going to be using push notifications in your app, see [this doc](https://firebase.google.com/docs/cloud-messaging/ios/certs#create_the_authentication_key) on how to create a new APN key. *Note: Create a APN key, not a certificate. Keys can be used by multiple environments, debug/release config, and don't expire.* Once you have that key created, you will need to see [this doc](https://firebase.google.com/docs/cloud-messaging/ios/client#upload_your_apns_authentication_key) on how to upload this new APN key to Firebase. 

Once that is setup, I recommend reading through the `AppDelegate.swift` file as it contains listeners for many FCM tasks you may want to handle.  

