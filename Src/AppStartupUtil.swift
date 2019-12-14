import Foundation

protocol StartupUtil {
    func runStartupTasks(_ onComplete: @escaping (Error?) -> Void)
}

// sourcery: InjectRegister = "StartupUtil"
class AppStartupUtil: StartupUtil {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func runStartupTasks(_ onComplete: @escaping (Error?) -> Void) {
        coreDataManager.loadStore { error in
            onComplete(error)
        }
    }
}
