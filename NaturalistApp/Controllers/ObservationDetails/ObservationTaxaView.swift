//
//  ObservationTaxaView.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

class ObservationTaxaView: UIView, NibInstantiable {
    @IBOutlet weak var taxaPhotoImageView: UIImageView!
    @IBOutlet weak var taxaNameLabel: UILabel!
    @IBOutlet weak var taxaSciNameLabel: UILabel!

    func setup(taxon: Taxon?) {
        guard let taxon = taxon else {
            self.isHidden = true
            return
        }
        taxaPhotoImageView.kf.setImage(with: taxon.defaultPhoto?.squareUrl)
        taxaNameLabel.text = taxon.preferredCommonName
        var prefix = ""
        if taxon.rank != .species {
            prefix = taxon.rank.rawValue.uppercasedFirstLetter() + " "
        }
        taxaSciNameLabel.text = prefix + taxon.name
    }
}
