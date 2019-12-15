import Empty
import Foundation
import PleaseHold

enum ThemeFake {
    case ugly

    var theme: Theme {
        switch self {
        case .ugly: return Theme(name: "ugly",
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
}
