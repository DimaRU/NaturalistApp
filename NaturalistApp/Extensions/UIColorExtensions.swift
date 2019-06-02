/////
////  UIColorExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(color: Int) {
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
}

