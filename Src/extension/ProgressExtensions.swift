import Foundation

extension Progress {
    convenience init(completed: Int, total: Int) {
        self.init(totalUnitCount: Int64(total))
        self.completedUnitCount = Int64(completed)
    }
}
