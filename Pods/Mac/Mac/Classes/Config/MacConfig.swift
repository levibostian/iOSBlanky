//
//  MacConfig.swift
//  Pods
//
//  Created by Levi Bostian on 4/3/17.
//
//

import Foundation
import iOSBoilerplate

public class MacConfigBuilder {
    
    public var macProcessApiResponse: MacProcessApiResponse?
    public var macErrorNotifier: MacErrorNotifier?
    public var macTasksRunnerManager: MacTasksRunnerManager?
    public var macAlamofireConfig: MacAlamofireConfig?
    
    public typealias BuilderClosure = (MacConfigBuilder) -> ()
    
    public init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
    
}

internal var MacConfigInstance: MacConfig? = nil
public struct MacConfig {
    
    let macProcessApiResponse: MacProcessApiResponse
    let macErrorNotifier: MacErrorNotifier
    let macTasksRunnerManager: MacTasksRunnerManager
    let macAlamofireConfig: MacAlamofireConfig
    
    public init?(builder: MacConfigBuilder) {
        if let processApiResponse = builder.macProcessApiResponse, let errorNotifier = builder.macErrorNotifier, let tasksRunner = builder.macTasksRunnerManager, let macAlamofireConfig = builder.macAlamofireConfig {
            self.macProcessApiResponse = processApiResponse
            self.macErrorNotifier = errorNotifier
            self.macTasksRunnerManager = tasksRunner
            self.macAlamofireConfig = macAlamofireConfig
            
            MacConfigInstance = self
        } else {
            return nil
        }
    }
    
}
