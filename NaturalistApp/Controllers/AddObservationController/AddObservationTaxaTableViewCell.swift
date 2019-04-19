//
//  AddObservationTaxaTableViewCell.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 18/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class AddObservationTaxaTableViewCell: UITableViewCell {
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
