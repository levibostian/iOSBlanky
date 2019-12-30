import Foundation
import Wendy

class AppPendingTasksFactory: PendingTasksFactory {
    func getTask(tag: String) -> PendingTask {
        switch tag {
        default: fatalError("Forgot case for tag: \(tag)")
        }
    }
}
