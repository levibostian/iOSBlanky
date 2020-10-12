ios_version = '11.0'

project "App.xcodeproj"
platform :ios, ios_version
use_frameworks!
inhibit_all_warnings!

def app_pods 
    pod 'Moya', '~> 14.0.0'
    pod 'RxCocoa', '~> 5'
    pod "RxCoreData", "~> 1.0.0"

    pod 'Firebase/Analytics'
    pod 'Firebase/RemoteConfig'
    pod 'Firebase/Messaging'
    pod 'Firebase/DynamicLinks'
    pod 'Firebase/Performance'
    pod 'Firebase/Crashlytics'

    pod 'Boquila', '1.0.0-alpha.4'
    pod 'Boquila/Firebase', '1.0.0-alpha.4'
    pod 'Boquila/Testing', '1.0.0-alpha.4'

    pod 'Dwifft', '~> 0.9'
    pod 'SwiftCoordinator'
    pod 'Kingfisher', '~> 5'
    pod 'KeychainAccess', '~> 4'
    pod 'Empty', '~> 0.1'
    pod 'PleaseHold', '~> 0.2'
    pod 'Swapper', '~> 1'
    pod 'IQKeyboardManagerSwift', '~> 6'
    pod 'Wendy', '~> 0.5.0'
    pod 'SnapKit', '~> 5.0.0'
    pod 'Teller', '~> 0.8.0'
end 

target "App" do
    app_pods()

    target "AppTests" do
        inherit! :search_paths

        pod 'RxBlocking', '~> 5.0'
        pod 'RxTest', '~> 5.0'
    end
end

# UI tests are separate apps. They need to be a root level app just like our app. 
target "AppUITests" do
    app_pods()
    
    pod 'RxBlocking', '~> 5.0'
    pod 'RxTest', '~> 5.0'
end

target "Screenshots" do
    app_pods()
    
    pod 'RxBlocking', '~> 5.0'
    pod 'RxTest', '~> 5.0'
end

# https://stackoverflow.com/a/58367269/1486374
post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = ios_version
      end
    end
end