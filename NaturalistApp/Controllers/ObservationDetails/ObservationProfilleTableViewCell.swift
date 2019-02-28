//
//  ObservationProfilleTableViewCell.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

class ObservationProfilleTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var observationDateLabel: UILabel!
    
    
    func setup(observation: Observation) {
        let user = observation.user
        if let icon = user.icon {
            avatarImageView.kf.setImage(with: icon)
        } else {
            avatarImageView.image = UIImage(named: "IC Account Circle 24px")
        }
        userNameLabel.text = user.login
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        observationDateLabel.text = dateFormatter.string(from: observation.createdAt)
    }
}
