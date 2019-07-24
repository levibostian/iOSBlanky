import Foundation
import Swinject

extension ServiceEntry {
    func singleton() {
        inObjectScope(.container)
    }
}
