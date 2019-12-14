import Foundation

protocol ViewControllerUnitTest {
    var viewControllerTestUtil: ViewControllerTestUtil { get }

    func loadViewController()
}
