import Foundation

extension Date {
    // Returns "5 hours ago" type of human readable text.
    func humanReadableTimeAgoSince(numericDates: Bool = true) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components: DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute, NSCalendar.Unit.hour, NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())

        if components.year! >= 2 {
            return "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if components.month! >= 2 {
            return "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if components.day! >= 2 {
            return "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }

    // Get a short, human readable string for the Date object. Note: This is only for the *date*, not the *time*.
    // Example: `Jan 1` if it's in the same year. Or, `Jan 1, 2019` if older year
    var humanReadableDate: String {
        let dateFormatter = DateFormatter.from(string: "MMM d")

        if !isInCurrentYear {
            dateFormatter.dateFormat = "MMM d, yyyy"
        }

        return dateFormatter.string(from: self)
    }

    static var formatter: DateFormatter {
        DateFormatter.from(string: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }

    static func from(_ dateString: String) -> Date? {
        formatter.date(from: dateString)
    }

    /// Year, month, day all start at 1. Not zero based.
    static func from(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date? {
        var calendarComponents: [Calendar.Component] = []

        if year != nil {
            calendarComponents.append(.year)
        }
        if month != nil {
            calendarComponents.append(.month)
        }
        if day != nil {
            calendarComponents.append(.day)
        }
        if hour != nil {
            calendarComponents.append(.hour)
        }
        if minute != nil {
            calendarComponents.append(.minute)
        }
        if second != nil {
            calendarComponents.append(.second)
        }

        var components = Calendar.current.dateComponents(Set(calendarComponents), from: Date.today)

        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second

        return Calendar.current.date(from: components)
    }

    func set(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date? {
        Date.from(year: year ?? self.year, month: month ?? self.month, day: day ?? self.day, hour: hour ?? self.hour, minute: minute ?? self.minute, second: second ?? self.second)
    }

    func add(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        var component = DateComponents()

        component.year = year
        component.month = month
        component.day = day
        component.hour = hour
        component.minute = minute
        component.second = second

        return Calendar.current.date(byAdding: component, to: self)!
    }

    func subtract(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        var component = DateComponents()

        component.year = year?.negated
        component.month = month?.negated
        component.day = day?.negated
        component.hour = hour?.negated
        component.minute = minute?.negated
        component.second = second?.negated

        return Calendar.current.date(byAdding: component, to: self)!
    }

    func stringValue(format: FormatString, modifications: [ModifyDateString] = []) -> String {
        let dateFormatter = DateFormatter.from(string: format.formatString)

        var dateString = dateFormatter.string(from: self)

        modifications.forEach { modifier in
            dateString = modifier.modify(dateString)
        }

        return dateString
    }

    var stringValue: String {
        Date.formatter.string(from: self)
    }

    static var today: Date { Date() }

    static var now: Date { Date() }

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

    var startOfDay: Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    var endOfDay: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

    // not zero indexed. starts at 1
    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }

    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }

    var second: Int {
        Calendar.current.component(.second, from: self)
    }

    static var random: Date {
        let randomYear = Int.random(in: 1980 ..< 2020)
        let randomMonth = Int.random(in: 1 ... 12)
        let randomDay = Int.random(in: 1 ... 28)

        let randomHour = Int.random(in: 0 ... 23)
        let randomMinute = Int.random(in: 0 ... 59)
        let randomSecond = Int.random(in: 0 ... 59)

        return Date.from("\(randomYear)-\(randomMonth)-\(randomDay)T\(randomHour):\(randomMinute):\(randomSecond)-06:00")!
    }

    var isLastDayOfMonth: Bool {
        dayAfter.month != month
    }

    var isInCurrentYear: Bool {
        let yearValue = Calendar.current.component(.year, from: self)

        let currentYear = Calendar.current.component(.year, from: Date.today)

        return yearValue == currentYear
    }

    // Thanks, https://stackoverflow.com/a/28163560/1486374
    func daysBetween(_ otherDate: Date) -> Int {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: otherDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)

        return components.day!
    }

    /**
     Generate a sequence between 2 dates. This allows you to do cool things like for looping between 2 Dates.
     ```
     for date in startDate.sequence(to: endDate, by: .day) {
         ...
     }
     ```
     */
    func sequence(to endDate: Date, by stepUnit: Calendar.Component, stepValue: Int = 1) -> DateRange {
        var startDate = self
        var endDate = endDate

        if endDate < startDate {
            startDate = endDate
            endDate = self
        }

        return DateRange(calendar: Calendar.current, startDate: startDate, endDate: endDate, stepUnit: stepUnit, stepValue: stepValue, multiplier: 0)
    }
}

extension DateFormatter {
    static func from(string: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = string
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }
}

// Way to define all date format strings. Makes them testable and not having to worry about typos.
// This website is handy to help make these: https://nsdateformatter.com/
enum FormatString {
    case shortMonthDay // Example: "Jan 1"
    case time12hr // Example: 1:00PM, 1:15AM

    var formatString: String {
        switch self {
        case .shortMonthDay: return "MMM d"
        case .time12hr: return "h:mma"
        }
    }
}

enum ModifyDateString {
    case lowercase // Example: input - 1PM, output - 1pm
    case remove00 // Example: input - 1:00pm, output - 1pm. input - 1:15pm, output - 1:15pm

    func modify(_ dateString: String) -> String {
        switch self {
        case .lowercase: return dateString.lowercased()
        case .remove00: return dateString.replacingOccurrences(of: ":00", with: "")
        }
    }
}

/**
 Creates a sequence between 2 dates. This allows you to do things like make a for loop between 2 dates.
 There are Date extension functions that create instanceds of this struct. You don't need to use it directly. The extensions make this easier.

 Thanks, https://gist.github.com/preble/b08b6d9ee161534e6c1f
 */
struct DateRange: Sequence, IteratorProtocol {
    var calendar: Calendar
    var startDate: Date
    var endDate: Date
    var stepUnit: Calendar.Component
    var stepValue: Int
    var multiplier: Int

    mutating func next() -> Date? {
        guard let nextDate = calendar.date(byAdding: stepUnit, value: stepValue * multiplier, to: startDate) else {
            return nil
        }

        if nextDate > endDate {
            return nil
        } else {
            multiplier += 1

            return nextDate
        }
    }
}
