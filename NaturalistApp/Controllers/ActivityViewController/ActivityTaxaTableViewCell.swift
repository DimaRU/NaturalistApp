/////
////  ActivityTaxaTableViewCell.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ActivityTaxaTableViewCell: UITableViewCell {
    var taxaView: ObservationTaxaView!
    @IBOutlet weak var taxaContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taxaView = ObservationTaxaView.instantiate()
        taxaContainerView.addSubview(taxaView)
    }
    
    func setup(taxon: Taxon?) {
        taxaView.setup(taxon: taxon)
    }
}
