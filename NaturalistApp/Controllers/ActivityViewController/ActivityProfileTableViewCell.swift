/////
////  ActivityProfileTableViewCell.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ActivityProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var agoLabel: UILabel!
    
    func setup(activity: ActivityViewController.Activity) {
        let user = activity.user
        avatarImageView.kf.setImage(with: user.icon,
                                    placeholder: UIImage(named: "IC Account Circle 24px")?.maskWith(color: .lightGray))
        agoLabel.text = activity.creationDate.smartDatePeriod(to: Date())
        let suffix: String
        switch activity {
        case .ident:
            suffix = NSLocalizedString("suggested an ID", comment: "")
        case .comment:
            suffix = NSLocalizedString("commented", comment: "")
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
