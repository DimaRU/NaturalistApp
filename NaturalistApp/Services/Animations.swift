/////
////  Animations.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class Animations {
    @discardableResult
    static func jiggle(view: UIView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.33, delay: 0, animations: {
            UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                    view.transform = CGAffineTransform(rotationAngle: -.pi/32)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
                    view.transform = CGAffineTransform(rotationAngle: +.pi/32)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1.0) {
                    view.transform = CGAffineTransform.identity
                }
            }, completion: nil)
        }, completion: { _ in
            view.transform = .identity
        })
    }
}
