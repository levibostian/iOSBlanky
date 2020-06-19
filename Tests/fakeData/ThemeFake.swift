import Empty
import Foundation
import PleaseHold

struct ThemeFakes {
    var ugly: Theme {
        Theme(name: "ugly",
              textColor: .blue,
              buttonColor: .green,
              viewControllerBackgroundColor: .red,
              navigationBarTextColor: .green,
              navigationBarItemColor: .blue,
              navigationBarColor: .green,
              statusBarStyle: .default,
              emptyViewStyle: EmptyViewConfig.light,
              pleaseHoldViewStyle: PleaseHoldViewConfig.light)
    }
}

extension Theme {
    static var fake: ThemeFakes {
        ThemeFakes()
    }
}
