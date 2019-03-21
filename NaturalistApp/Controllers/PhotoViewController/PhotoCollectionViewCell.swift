//
//  PhotoCollectionViewCell.swift
//  PhotoViewController
//
//  Created by Dmitriy Borovikov on 16/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var captionBar: UIView!
    var image: UIImage? {
        set {
            imageView.image = newValue
            blurredImageView.image = newValue
        }
        get {
            return imageView.image
        }
    }
    var caption: String? {
        get {
            return captionLabel.text
        }
        set {
            captionLabel.text = newValue
            if newValue == nil {
                captionLabel.isHidden = true
                captionBar.isHidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        image = nil
    }
    
    func setup(url: URL, caption: String?, contentMode: UIView.ContentMode) {
        imageView.contentMode = contentMode
        self.caption = caption
        imageView.kf.indicatorType = .custom(indicator: PhotoActivityIndicator(style: .whiteLarge))
        imageView.kf.setImage(with: url, placeholder: nil)
        { result in
            if case .success(let value) = result {
                self.blurredImageView.image = value.image
            }
        }
    }
}
