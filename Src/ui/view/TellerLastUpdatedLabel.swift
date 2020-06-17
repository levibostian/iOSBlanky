import Foundation
import SnapKit
import UIKit

/**
 Label that displays how old the cached data is.
 */
class TellerLastUpdatedLabel: UILabel {
    private var textTimer: Timer?
    private var lastUpdated: Date?

    func setDataState<T: Any>(_ dataState: CacheState<T>) {
        if case .cache(let cache, let cacheAge) = dataState.state {
            self.lastUpdated = cacheAge

            isHidden = false
            textTimer?.invalidate()
            updateText()

            textTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.updateText()
            }
        }
    }

    private func updateText() {
        guard let lastUpdated = lastUpdated else {
            isHidden = true
            return
        }

        text = "Last synced: \(lastUpdated.humanReadableTimeAgoSince())"
    }

    deinit {
        textTimer?.invalidate()
    }

    convenience init() {
        self.init(frame: CGRect.zero)

        build()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        build()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func build() {
        isHidden = true // hide by default

        textColor = Colors.textColor.color
        font = UIFont.systemFont(ofSize: 11, weight: .thin)
    }
}
