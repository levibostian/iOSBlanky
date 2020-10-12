import Foundation
import UIKit

extension UIView {
    // An animation that is a "pulse" kind of animation.
    // Demo: https://github.com/theagendaperiod/TheAgendaPeriod/issues/1#issuecomment-676547529 (demo is using scale of 1.6
    func animateScaleUpAndDown(upDuration: TimeInterval, downDuration: TimeInterval, scale: CGFloat = 1.6, upOptions: UIView.AnimationOptions = .curveEaseIn, downOptions: UIView.AnimationOptions = .curveEaseOut, onComplete: OnComplete?) {
        UIView.animate(withDuration: upDuration, delay: 0, options: upOptions, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { _ in
            UIView.animate(withDuration: downDuration, delay: 0, options: downOptions, animations: { [weak self] in
                guard let self = self else { return }
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { _ in
                onComplete?()
            })
        })
    }

    /// Animate on the X axis onto the screen to the View's original position it was added to.
    /// Use along with `animateSlideOutX()`
    func animateSlideInX(duration: TimeInterval, options: UIView.AnimationOptions = .curveEaseIn, onComplete: OnComplete?) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(translationX: 0, y: 0.0)
        }, completion: { _ in
            onComplete?()
        })
    }

    // Animate on the X axis off the screen.
    func animateSlideOutX(duration: TimeInterval, direction: AnimationDirectionHorizontal, options: UIView.AnimationOptions = .curveEaseOut, onComplete: OnComplete?) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            guard let self = self else { return }

            var xPosition: CGFloat = 1000 // using 1000 as it's a big number and more then likely the view will be off the screen.
            switch direction {
            case .left:
                xPosition = -1000
            case .right:
                xPosition = 1000
            }

            self.transform = CGAffineTransform(translationX: xPosition, y: 0.0)
        }, completion: { _ in
            onComplete?()
        })
    }
}

enum AnimationDirectionHorizontal {
    case right
    case left
}
