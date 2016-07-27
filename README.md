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
* Open project settings and (1) change team name, (2) change target name, (3) change bundle identifier. Quit XCode. 
* Open `Podfile` in a text editor. Edit the Podfile's "target" to the name of the new target name you set above ^^^. Run `pod install` again. 
* Open `.swiftlint.yml` file and edit `iOSBlanky` in `Sources` to name of your source directory.
* Open coolNewApp XCode workspace file again in XCode.
* Open project settings > General, scroll to bottom to view the list of all cocoapods/frameworks you have installed in app. Delete `Pods_iOSBlanky.framework`. Quit XCode. 
* In finder, rename the iOSBlanky source code directory to coolNewApp. Repeat for iOSBlankyTests and iOSBlankyUITests.
* Open coolNewApp XCode workspace file in XCode. Along left side where you view all of the files in your project, click on the iOSBlanky group folder. Open the right panel of XCode and you will see a folder icon. Click this and choose the newly renamed folder you edited in the step above ^^^. Repeat this for the iOSBlankyTests and iOSBlankyUITests groups as well. 
* Open project settings > General in XCode again. Scroll to bottom to view the list of all cocoapods/frameworks installed. Remove Pods_coolNewApp.framework, then add it back. Then the top screen will ask you to locate your Info.plist file. Choose coolNewApp/Info.plist. 
* Now you can select in the schemas list by the Play button in XCode your target name coolNewApp and then run on device. 