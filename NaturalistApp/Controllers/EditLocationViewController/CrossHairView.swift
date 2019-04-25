//
//  CrossHairView.swift
//  MapTest
//
//  Created by Dmitriy Borovikov on 23/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import CoreLocation

class CrossHairView: EditLocationOverlayView {
    private let latLabel = UILabel()
    private let lngLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLabels()
    }
    
    private func initLabels() {
        addSubview(makeLabel(lngLabel, rect: CGRect(x: bounds.size.width / 2 + 2,
                                                    y: (bounds.size.height / 2) - (bounds.size.width / 4) - 21,
                                                    width: bounds.size.width / 4, height: 20)))
        addSubview(makeLabel(latLabel, rect: CGRect(x: 2,
                                                    y: bounds.size.height / 2 + 2,
                                                    width: bounds.size.width / 4, height: 20)))
        latLabel.text = "lat:"
        lngLabel.text = "lng:"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        lngLabel.superview?.frame = CGRect(x: bounds.size.width / 2 + 2,
                                           y: (bounds.size.height / 2) - (bounds.size.width / 4) - 21,
                                           width: bounds.size.width / 4, height: 20)
        latLabel.superview?.frame = CGRect(x: 2,
                                           y: bounds.size.height / 2 + 2,
                                           width: bounds.size.width / 4, height: 20)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setAllowsAntialiasing(false)
        context.setLineWidth(1)
        color.setStroke()
        context.move(to: CGPoint(x: bounds.origin.x, y: bounds.size.height / 2))
        context.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height / 2))
        context.move(to: CGPoint(x: bounds.size.width / 2, y: bounds.origin.y))
        context.addLine(to: CGPoint(x: bounds.size.width / 2, y: bounds.size.height))
        context.strokePath()
    }
    
    public func show(coordinate: CLLocationCoordinate2D) {
        latLabel.text = "lat: \(Float(coordinate.latitude))"
        lngLabel.text = "lng: \(Float(coordinate.longitude))"
    }
}
