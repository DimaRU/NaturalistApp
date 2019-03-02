//
//  ObservationFaveTableViewCell.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ObservationFaveTableViewCell: UITableViewCell {
    @IBOutlet weak var favoritedLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    var favedByMe: Bool = false {
        didSet {
            starImageView.image = UIImage(named: favedByMe ? "IC Star 24px" : "IC Star Border 24px")
        }
    }
    func setup(observation: Observation) {
        favoritedLabel.text = "Favored: " + String(observation.favesCount)
        favedByMe = observation.favedByMe
    }
}
