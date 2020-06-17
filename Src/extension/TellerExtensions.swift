import Foundation

extension Array where Element == RefreshResult {
    var firstUnsuccessful: RefreshResult? {
        first { (refreshResult) -> Bool in
            guard case .successful = refreshResult else {
                return true
            }
            return false
        }
    }
}
