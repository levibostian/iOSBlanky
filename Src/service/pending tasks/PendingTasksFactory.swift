import Foundation
import Wendy

class AppPendingTasksFactory: PendingTasksFactory {
    func getTask(tag: String) -> PendingTask {
        switch tag {
        case FavoriteRepoPendingTask.tag: return FavoriteRepoPendingTask()
        default: fatalError("Forgot case for tag: \(tag)")
        }
    }
}
