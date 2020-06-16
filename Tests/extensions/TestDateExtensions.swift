import Foundation

extension Date {
    // Thanks, https://stackoverflow.com/a/44009988/1486374
    static var yesterday: Date { Date().dayBefore }
    static var tomorrow: Date { Date().dayAfter }
    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }

    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }

    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var isLastDayOfMonth: Bool {
        dayAfter.month != month
    }
}
