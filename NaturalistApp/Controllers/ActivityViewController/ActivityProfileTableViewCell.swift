//
//  ActivityProfileTableViewCell.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 13/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ActivityProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var agoLabel: UILabel!
    weak var delegate: ObservationDetailProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc func tapView(_ sender: Any) {
        delegate?.showUserProfile()
    }
    
    func setup(activity: ActivityViewController.Activity, delegate: ObservationDetailProtocol) {
        self.delegate = delegate
        let user = activity.user
        avatarImageView.kf.setImage(with: user.icon,
                                    placeholder: UIImage(named: "IC Account Circle 24px")?.maskWith(color: .lightGray))
        agoLabel.text = activity.creationDate.smartDatePeriod(to: Date())
        let suffix: String
        switch activity {
        case .ident:
            suffix = "suggested an ID"
        case .comment:
            suffix = "commented"
        }
        
        let labelText = NSMutableAttributedString(string: user.login, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        labelText.append(NSAttributedString(string: " " + suffix, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        if case .ident(let ident) = activity, !ident.current {
            labelText.addAttributes([
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.black],
                                    range: NSMakeRange(0, labelText.length))
        }
        userNameLabel.attributedText = labelText
    }
}
