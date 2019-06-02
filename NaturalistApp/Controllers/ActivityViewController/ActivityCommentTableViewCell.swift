/////
////  ActivityCommentTableViewCell.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ActivityCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var bodyTextView: UITextView!
    
    func setup(comment: Comment) {
        bodyTextView.text = ""
        guard let data = comment.body.data(using: .utf8) else { return }
        guard let body = try? NSMutableAttributedString(data: data,
                                                 options: [.documentType: NSAttributedString.DocumentType.html,
                                                           .characterEncoding: String.Encoding.utf8.rawValue],
                                                 documentAttributes: nil)
            else { return }
        
        let range = NSRange(location: 0, length: body.length)
        body.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: range)
        bodyTextView.attributedText = body
        selectionStyle = .none
    }
}
