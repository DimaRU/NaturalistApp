//
//  TaxonWebContentView.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 18/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class TaxonWebContentView: UIView, NibInstantiable {
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var wikiLinkButton: UIButton!
    weak var delegate: TaxonDetailProtocol?
    
    @IBAction func wikiLinkTap(_ sender: Any) {
        delegate?.showWikipediaPage()
    }
    @IBAction func inaturalistLinkTap(_ sender: Any) {
        delegate?.openInaturalist()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.isHidden = true
        wikiLinkButton.isHidden = true
    }
    
    func setup(taxon: Taxon, delegate: TaxonDetailProtocol) {
        self.delegate = delegate
        commonNameLabel.text = taxon.preferredCommonName
        scientificNameLabel.text = taxon.name

        guard var webContent = taxon.wikipediaSummary, !webContent.isEmpty else { return }
        let annotation = "(Source: Wikipedia)"
        webContent += " \(annotation.localizedString)"
        guard let data = webContent.data(using: .utf8), !data.isEmpty else { return }
        guard let body = try? NSMutableAttributedString(data: data,
                                                        options: [.documentType: NSAttributedString.DocumentType.html,
                                                                  .characterEncoding: String.Encoding.utf8.rawValue],
                                                        documentAttributes: nil) else { return }
        
        let range = NSRange(location: 0, length: body.length)
        body.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: range)
        descriptionTextView.attributedText = body
        descriptionTextView.isHidden = false
        if taxon.wikipediaUrl != nil {
            wikiLinkButton.isHidden = false
        }
    }
}
