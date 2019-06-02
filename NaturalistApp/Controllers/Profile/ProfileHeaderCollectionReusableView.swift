/////
////  ProfileHeaderCollectionReusableView.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var observationsCountLabel: UILabel!
    @IBOutlet weak var identificationsCountLabel: UILabel!

    private var user: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureData(user: User) {
        self.user = user
        avatarImageView.kf.setImage(with: user.icon,
                                    placeholder: UIImage(named: "IC Account Circle 24px")?.maskWith(color: .lightGray))
        userNameLabel.text = user.name ?? user.login
        observationsCountLabel.text = NSLocalizedString("Observations: ", comment: "") +
            String(user.observationsCount)
        identificationsCountLabel.text = NSLocalizedString("Species: ", comment: "") +
            String(user.identificationsCount)

    }
}
