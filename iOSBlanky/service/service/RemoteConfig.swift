//
//  RemoteConfig.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/23/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import Firebase

protocol RemoteConfigProvider {
    var someRemoteConfigValue: String { get }
    func fetch()
}

class FirebaseRemoteConfig: RemoteConfigProvider {

    fileprivate let remoteConfig = RemoteConfig.remoteConfig()
    fileprivate let logger = Di.inject.activityLogger

    init() {
        remoteConfig.setDefaults(fromPlist: "FirebaseRemoteConfigDefaults")
    }

    var someRemoteConfigValue: String {
        return self.remoteConfig["some_remote_config_value"].stringValue!
    }

    // You usually want to call this during the launch of your application.
    func fetch() {
        self.remoteConfig.fetch { (status, error) in
            if status == .success {
                self.remoteConfig.activate()
            } else if let error = error {
                self.logger.errorOccurred(error)
            }
        }
    }

}
