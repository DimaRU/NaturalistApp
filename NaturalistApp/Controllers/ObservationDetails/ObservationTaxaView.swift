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
    weak var delegate: ObservationDetailProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc func viewTap() {
        delegate?.showTaxaDetails()
    }

    func setup(observation: Observation, delegate: ObservationDetailProtocol) {
        self.delegate = delegate
        guard let taxa = observation.taxon else {
            self.isHidden = true
            return
        }
        taxaPhotoImageView.kf.setImage(with: taxa.defaultPhoto?.squareUrl)
        taxaNameLabel.text = taxa.name
        taxaSciNameLabel.text = taxa.preferredCommonName
    }
}
