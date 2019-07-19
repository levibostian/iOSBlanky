//
//  Container.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import Swinject

class Di { // swiftlint:disable:this type_name

    static var container: DiContainer = DiContainer()

    private init() {
    }

}

protocol InjectDependencyGraph {
    var activityLogger: ActivityLogger { get }
}

class DiContainer: InjectDependencyGraph {

    fileprivate let container: Container = Container()

    init() {
        self.registerDependencies()
    }

    private func registerDependencies() {
        self.container.register(ActivityLogger.self) { _ in AppActivityLogger() }
    }

    var activityLogger: ActivityLogger {
        return inject(.activityLogger)
    }

    func inject<T>(_ dep: Dependency) -> T {
        return resolve(dep) as! T // swiftlint:disable:this force_cast
    }

    private func resolve(_ dep: Dependency) -> Any {
        switch dep {
        case .activityLogger: return container.resolve(ActivityLogger.self)! as Any
        }
    }

}
