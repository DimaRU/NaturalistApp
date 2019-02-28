//
//  ObservationTaxaTableViewCell.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

class ObservationTaxaTableViewCell: UITableViewCell {
    @IBOutlet weak var taxaPhotoImageView: UIImageView!
    @IBOutlet weak var taxaNameLabel: UILabel!
    @IBOutlet weak var taxaSciNameLabel: UILabel!
    
    func setup(observation: Observation) {
        guard let taxa = observation.taxon else {
            self.isHidden = true
            return
        }
        if let url = taxa.defaultPhoto?.squareUrl {
            taxaPhotoImageView.kf.setImage(with: url)
        }
        taxaNameLabel.text = taxa.name
        taxaSciNameLabel.text = taxa.preferredCommonName
    }
}
