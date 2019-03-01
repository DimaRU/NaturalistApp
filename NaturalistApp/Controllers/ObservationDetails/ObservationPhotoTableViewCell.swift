//
//  ObservationPhotoTableViewCell.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ObservationPhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!

    func setup(observation: Observation) {
        guard let photo = observation.photos.first else {
            self.isHidden = true
            return
        }
        photoImageView.kf.setImage(with: photo.mediumUrl)
    }
}
