/////
////  TaxaTableViewCell.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class TaxaTableViewCell: UITableViewCell {
    var taxaView: ObservationTaxaView!

    override func awakeFromNib() {
        super.awakeFromNib()
        taxaView = ObservationTaxaView.instantiate()
        contentView.addSubview(taxaView)
    }

    func setup(taxon: Taxon?) {
        taxaView.setup(taxon: taxon)
    }
}
