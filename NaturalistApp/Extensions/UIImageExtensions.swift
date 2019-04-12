//
//  UIImageExtensions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 26/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    public func JPEGDataRepresentation(withMetadata metadata: [AnyHashable: Any], location: CLLocation?) -> Data {
        return autoreleasepool { () -> Data in
            var mutableMetadata = metadata
            if let location = location {
                mutableMetadata[kCGImagePropertyGPSDictionary] = location.exifGPSMetadata()
            }
            let jpegData = self.jpegData(compressionQuality: 1.0)!
            let source = CGImageSourceCreateWithData(jpegData as CFData, nil)!
            
            let destData = NSMutableData()
            let destination = CGImageDestinationCreateWithData(destData as CFMutableData, "public.jpeg" as CFString, 1, nil)!
            CGImageDestinationAddImageFromSource(destination, source, 0, mutableMetadata as CFDictionary)
            CGImageDestinationFinalize(destination)
            return destData as Data
        }
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
