import Foundation

// From: https://stackoverflow.com/a/44910195/1486374
extension TimeInterval {
    private var milliseconds: Int {
        return Int(truncatingRemainder(dividingBy: 1) * 1000)
    }

    private var seconds: Int {
        return Int(self) % 60
    }

    private var minutes: Int {
        return (Int(self) / 60) % 60
    }

    private var hours: Int {
        return Int(self) / 3600
    }

    var humanReadable: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }

    var ignoreMillis: TimeInterval {
        return rounded(.down)
    }
}
