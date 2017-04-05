# iOSBlanky
Blank project for iOS to get up and running FAST. 

# Create iOS project from iOSBlanky:

(below, replace all instances of `coolNewApp` with the name of your new project.)
* `cp -R iOSBlanky/ coolNewApp`
* `cd coolNewApp/`
* `rm -rf .git/`
* `git init`
* `git config user.email "your@email.com"`
* `git config user.name "Your name"`
* `git add .`
* `git commit -m "Initial commit. Create new project from iOSBlanky"`
* `pod install`
* Open coolNewApp XCode workspace file in XCode
* Open project settings and (1) change the team the app belongs to, (2) change target name (found in the right panel of XCode), (3) change bundle identifier. Quit XCode. 
* Open `Podfile` in a text editor. Edit the Podfile's "target" to the name of the new target name you set above ^^^. Run `pod install` again. Then, remove the old workspace file: `rm iOSBlanky.xcworkspace`. Also, delete the LICENSE file if you're writing closed source: `rm LICENSE`
* Open `.swiftlint.yml` file and edit `iOSBlanky` in `Sources` to name of your source directory.
* Open coolNewApp XCode workspace file again in XCode.
* Open project settings > General, scroll to bottom to view the list of all cocoapods/frameworks you have installed in app. Delete `Pods_iOSBlanky.framework`. Quit XCode. 
* In finder, rename the iOSBlanky source code directory to coolNewApp. Repeat for iOSBlankyTests and iOSBlankyUITests.
* Open coolNewApp XCode workspace file in XCode. Along left side where you view all of the files in your project, click on the iOSBlanky group folder. Open the right panel of XCode and you will see a folder icon. Click this and choose the newly renamed folder you edited in the step above ^^^. Repeat this for the iOSBlankyTests and iOSBlankyUITests groups as well. Then, rename the group names in the left side panel (the folders with all of your code you were selecting and clicking on that folder icon in the right panel, those are called groups. They are not actually folders, just XCode organizers. Click on them and rename them to coolNewApp.)
* Open project settings > General in XCode again. Scroll to bottom to view the list of all cocoapods/frameworks installed. Remove Pods_coolNewApp.framework, then add it back. 
* Target > General in XCode. The middle where you usually enter your bundle identifier, it will have a button asking you to locate your Info.plist file. Choose coolNewApp/Info.plist. 
* Target > Build settings in XCode. Look for "Product Bundle Identifier" and "Product Name". Change these to the values you want for identifier and name of app.
* Top left corner by the Play and Stop button. You see the schemas with name "iOSBlanky". Click on it and go to "Manage schemas". You can now click on iOSBlanky and rename it to coolNewApp. 
* Hold down option key on keyboard and click on the Play button. You can now select in the list what build version you want to run. I start with debug/dev. Go ahead and try to run on a device now. 
* Continue on with dev. Install Fabric for instance. 
