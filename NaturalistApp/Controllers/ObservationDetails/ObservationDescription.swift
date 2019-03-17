//
//  ObservationDescription.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ObservationDescription: UIView, NibInstantiable {
    @IBOutlet weak var descriptionTextView: UITextView!
    
    func setup(description: String?) {
        descriptionTextView.text = nil
        isHidden = true
        guard let data = description?.data(using: .utf8), !data.isEmpty else { return }
        guard let body = try? NSMutableAttributedString(data: data,
                                                        options: [.documentType: NSAttributedString.DocumentType.html,
                                                                  .characterEncoding: String.Encoding.utf8.rawValue],
                                                        documentAttributes: nil)
            else { return }
        
        let range = NSRange(location: 0, length: body.length)
        body.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: range)
        descriptionTextView.attributedText = body
        isHidden = false
    }
}
