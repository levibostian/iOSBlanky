import Foundation
import UIKit

protocol CountdownTimerDelegate: AnyObject {
    func countedDownOneValue(_ timer: CountdownTimer)
    func countdownComplete(_ timer: CountdownTimer)
}

/**
 Allows you to have a timer that counts down.
 */
class CountdownTimer {
    private var timer: Timer?

    weak var delegate: CountdownTimerDelegate?

    private(set) var remaining: Int
    let total: Int
    let interval: TimeInterval

    init(total: Int, interval: TimeInterval) {
        self.total = total
        self.remaining = total
        self.interval = interval
    }

    func start() {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerIntervalCountedDown), userInfo: nil, repeats: true)
        timer?.tolerance = 0.3
    }

    func stop() {
        timer?.invalidate()
    }

    @objc func timerIntervalCountedDown() {
        remaining -= 1

        delegate?.countedDownOneValue(self)

        if remaining == 0 {
            delegate?.countdownComplete(self)
            stop()
        }
    }
}
