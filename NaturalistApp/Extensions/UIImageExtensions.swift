//
//  UIImageExtensions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 26/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func maskWith(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
    
}
