//
//  NSLayoutConstraintExtensions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 11/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    static func box(item item1: UIView, in item2: UILayoutGuide) {
        NSLayoutConstraint.activate([
            item1.leadingAnchor.constraint(equalTo: item2.leadingAnchor),
            item1.trailingAnchor.constraint(equalTo: item2.trailingAnchor),
            item1.topAnchor.constraint(equalTo: item2.topAnchor),
            item1.bottomAnchor.constraint(equalTo: item2.bottomAnchor)
            ])
    }
    
    static func box(item item1: UIView, in item2: UIView) {
        NSLayoutConstraint.activate([
            item1.leadingAnchor.constraint(equalTo: item2.leadingAnchor),
            item1.trailingAnchor.constraint(equalTo: item2.trailingAnchor),
            item1.topAnchor.constraint(equalTo: item2.topAnchor),
            item1.bottomAnchor.constraint(equalTo: item2.bottomAnchor)
            ])
    }
}

