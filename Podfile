source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def developmentDependencies
    pod 'SwiftFormat/CLI'
    pod 'SwiftLint'
end 

def commonDepencencies    
    pod 'Moya/RxSwift', '~> 14.0.0-alpha.1'
    pod 'RxCocoa', '~> 5.0.0'

    pod 'Swinject', '~> 2.6.2'

    pod 'Firebase/Analytics'
    pod 'Firebase/RemoteConfig'
    pod 'Firebase/Messaging'
    pod 'Firebase/DynamicLinks'
    pod 'Firebase/Performance'
    pod 'Fabric', '~> 1.10.2'
    pod 'Crashlytics', '~> 3.13.4'

    pod 'Kingfisher', '~> 5.7.0'
    pod 'KeychainAccess', '~> 3.2.0'
    pod 'DZNEmptyDataSet', '~> 1.8.1'
    pod 'IQKeyboardManagerSwift', '~> 6.4.0'
    pod 'Wendy', '~> 0.2.0-alpha'
    pod 'SnapKit', '~> 5.0.0'
    pod 'Teller', '~> 0.4.0-alpha'

    pod 'WoodPeckeriOS', :configurations => ['Debug']
end 

target 'iOSBlanky' do
    commonDepencencies()
    developmentDependencies()
end

target 'iOSBlankyTests' do
    commonDepencencies()
end

target 'iOSBlankyUITests' do
    commonDepencencies()
end

