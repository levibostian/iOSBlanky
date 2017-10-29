source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'iOSBlanky' do
    pod 'SwiftLint'
    pod 'SwiftOverlays', '~> 4.0.1'
    pod 'Moya/RxSwift', '~> 10.0.0'
    # pod 'Moya-ObjectMapper/RxSwift', '~> 2.4.2'
    pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/levibostian/Moya-ObjectMapper.git', :branch => 'swift4'
    pod 'RxCocoa', '~> 4.0.0'
    pod 'RxRealm', '~> 0.7.4'
    pod 'Kingfisher', '~> 4.2.0'
    pod 'KeychainAccess', '~> 3.1.0'
    pod 'DZNEmptyDataSet', '~> 1.8.1'
    pod 'IQKeyboardManagerSwift', '~> 5.0.4'
    pod 'RealmSwift', '~> 3.0.0'
end

target 'iOSBlankyTests' do
    # pod 'RealmSwift'# realm.io says to include in tests too. Comment out now as not using tests. Cocoapods complains about having dependency added twice.
end

target 'iOSBlankyUITests' do
    # pod 'RealmSwift'
end

