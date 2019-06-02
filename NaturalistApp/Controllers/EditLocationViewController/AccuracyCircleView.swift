/////
////  AccuracyCircleView.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class AccuracyCircleView: EditLocationOverlayView {
    let accLabel = UILabel()
    var radius: CGFloat = 100
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(makeLabel(accLabel, rect: CGRect(x: 0, y: 0,
                                                    width: bounds.size.width / 4, height: 20)))
        accLabel.text = "acc:"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(makeLabel(accLabel, rect: CGRect(x: 0, y: 0,
                                                    width: bounds.size.width / 4, height: 20)))
        accLabel.text = "acc:"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let coord45 = radius * cos(.pi / 4)
        accLabel.superview?.frame = CGRect(x: bounds.size.width / 2 + coord45 + 1,
                                           y: bounds.size.height / 2 + coord45 + 1,
                                           width: bounds.size.width / 5, height: 20)
        accLabel.textAlignment = .center
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        color.setStroke()
        context.addArc(center: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2),
                        radius: radius,
                        startAngle: 0,
                        endAngle: 2 * .pi,
                        clockwise: true)
        context.strokePath()
    }
    
    func set(accuracy: Double, radius: CGFloat) {
        self.isHidden = false
        let accInt = Int(accuracy)
        accLabel.text = "acc: \(accInt) m"
        self.radius = radius
        setNeedsDisplay()
    }
}
