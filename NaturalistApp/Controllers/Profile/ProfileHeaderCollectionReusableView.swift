//
//  ProfileHeaderCollectionReusableView.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 05/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var observationsCountLabel: UILabel!
    @IBOutlet weak var identificationsCountLabel: UILabel!

    private weak var delegate: ProfileDelegateProtocol?
    private var user: User!
    
    private func addTapReognizer(for view: UIView, action: Selector?) {
        let recognizer = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(recognizer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureData(user: User, delegate: ProfileDelegateProtocol) {
        self.user = user
        self.delegate = delegate
        avatarImageView.kf.setImage(with: user.icon,
                                    placeholder: UIImage(named: "IC Account Circle 24px")?.maskWith(color: .lightGray))
        userNameLabel.text = user.name ?? user.login
        observationsCountLabel.text = NSLocalizedString("Observations: ", comment: "") +
            String(user.observationsCount)
        identificationsCountLabel.text = NSLocalizedString("Species: ", comment: "") +
            String(user.identificationsCount)

    }
}
