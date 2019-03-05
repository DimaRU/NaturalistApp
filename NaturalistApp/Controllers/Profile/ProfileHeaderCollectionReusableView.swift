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
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    
    private weak var delegate: ProfileDelegateProtocol?
    private var user: User!
    
    private var currentUserFollowing: Bool = false {
        didSet {
            followingButton.setTitle(currentUserFollowing ? "Unfollow" : "Follow", for: .normal)
        }
    }
    
    private func addTapReognizer(for view: UIView, action: Selector?) {
        let recognizer = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(recognizer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapReognizer(for: followersLabel, action: #selector(followersTap(_:)))
        addTapReognizer(for: followingLabel, action: #selector(followingTap(_:)))
    }
    
    @IBAction func followersTap(_ sender: UITapGestureRecognizer) {
//        delegate?.presentUserList(.followers(userId: userId))
    }
    
    @IBAction func followingTap(_ sender: UITapGestureRecognizer) {
//        delegate?.presentUserList(.following(userId: userId))
    }
    
    @IBAction func followingButtonTap(_ sender: UIButton) {
    }
    
    
    public func configureData(user: User, delegate: ProfileDelegateProtocol) {
        self.user = user
        self.delegate = delegate
        avatarImageView.kf.setImage(with: user.icon,
                                    placeholder: UIImage(named: "IC Account Circle 24px")?.maskWith(color: .lightGray))
        userNameLabel.text = user.name ?? user.login
//        followersLabel.text = "Followers: " + String(user.followedByCount)
//        followingLabel.text = "Following: " + String(user.followsCount)
//        currentUserFollowing = user.currentUserFollowsThisUser
//        followingButton.isHidden = (userId == Globals.currentUserId)
    }
}
