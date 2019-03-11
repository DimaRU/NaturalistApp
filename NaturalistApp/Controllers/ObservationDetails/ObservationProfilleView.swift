//
//  ObservationProfilleView.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

class ObservationProfilleView: UIView, NibInstantiable {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var observationDateLabel: UILabel!
    @IBOutlet weak var observationsCountLabel: UILabel!
    weak var delegate: ObservationDetailProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc func viewTap() {
        delegate?.showUserProfile()
    }
    
    func setup(observation: Observation, delegate: ObservationDetailProtocol) {
        self.delegate = delegate
        let user = observation.user
        avatarImageView.kf.setImage(with: user.icon,
                                    placeholder: UIImage(named: "IC Account Circle 24px")?.maskWith(color: .lightGray))
        userNameLabel.text = user.login
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        observationDateLabel.text = dateFormatter.string(from: observation.createdAt)
        observationsCountLabel.text = NSLocalizedString("Observations: ", comment: "") +
            String(user.observationsCount)
    }
}
