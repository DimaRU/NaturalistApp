/////
////  TaxaSearchTableViewCell.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class TaxaSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var taxaPhotoImageView: UIImageView!
    @IBOutlet weak var taxaNameLabel: UILabel!
    @IBOutlet weak var taxaSciNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    func setupTaxon(taxon: Taxon) {
        taxaPhotoImageView.kf.setImage(with: taxon.defaultPhoto?.squareUrl)
        taxaNameLabel.text = taxon.preferredCommonName
        var prefix = ""
        if taxon.rank != .species {
            prefix = taxon.rank.rawValue.uppercasedFirstLetter() + " "
        }
        taxaSciNameLabel.text = prefix + taxon.name
        commentLabel.text = nil
    }

    func setupScore(taxonScore: TaxonScore) {
        setupTaxon(taxon: taxonScore.taxon)

        let frequencyScore = taxonScore.frequencyScore ?? 0
        let reason: String
        if taxonScore.visionScore > 0 && frequencyScore > 0 {
            reason = NSLocalizedString("Visually Similar / Seen Nearby", comment: "basis for a species suggestion")
        } else if taxonScore.visionScore > 0 {
            reason = NSLocalizedString("Visually Similar", comment: "basis for a species suggestion")
        } else if frequencyScore > 0 {
            reason = NSLocalizedString("Seen Nearby", comment: "basis for a suggestion")
        } else {
            reason = ""
        }
        commentLabel.text = reason
    }
}
