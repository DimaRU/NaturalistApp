//
//  ObservationPhotoView.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ObservationPhotoView: UIView, NibInstantiable {
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setup(observation: Observation) {
        photoImageView.kf.setImage(with: observation.photos.first?.mediumUrl) { _ in
            self.setNeedsLayout()
        }
    }
}
