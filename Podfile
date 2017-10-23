source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'iOSBlanky' do
    pod 'SwiftLint'
    pod 'SwiftOverlays', '~> 4.0.0'
    pod 'Moya/RxSwift', '~> 8.0.5'
    pod 'Moya-ObjectMapper/RxSwift', '~> 2.3.2'
    pod 'RxCocoa', '~> 3.4.0'
    pod 'Kingfisher', '~> 3.5.2'
    pod 'KeychainAccess', '~> 3.0.1'
    pod 'DZNEmptyDataSet', '~> 1.8.1'
    pod 'IQKeyboardManagerSwift', '~> 4.0.8'
    pod 'RealmSwift', '~> 2.10.2'
end

target 'iOSBlankyTests' do
    # pod 'RealmSwift'# realm.io says to include in tests too. Comment out now as not using tests. Cocoapods complains about having dependency added twice.
end

target 'iOSBlankyUITests' do
    # pod 'RealmSwift'
end

