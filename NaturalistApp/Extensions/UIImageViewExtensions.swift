//
//  UIImageViewExtensions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 25/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension UIImageView {
    func animationFromGif(resource: String) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "gif")
            else { return }
        guard let gifData = try? Data(contentsOf: url),
            let source = CGImageSourceCreateWithData(gifData as CFData, nil)
            else { return }
        let imageCount = CGImageSourceGetCount(source)
        self.animationImages = (0..<imageCount)
            .compactMap {CGImageSourceCreateImageAtIndex(source, $0, nil)}
            .map{ UIImage(cgImage: $0)}
    }
}
