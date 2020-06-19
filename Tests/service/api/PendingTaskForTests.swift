import Wendy

class PendingTaskForTests: PendingTask {
    static var tag: PendingTask.Tag = "Pending task for tests"

    var taskId: Double?
    var dataId: String?
    var manuallyRun: Bool = false
    var groupId: String?
    var createdAt: Date?

    convenience init(foo: String) {
        self.init()
        self.dataId = foo
    }

    func runTask(complete: @escaping (Error?) -> Void) {
        complete(nil)
    }

    func isReadyToRun() -> Bool {
        true
    }
}
