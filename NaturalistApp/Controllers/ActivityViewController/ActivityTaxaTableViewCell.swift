//
//  ActivityTaxaTableViewCell.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 12/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
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
    
    func setup(taxon: Taxon?, delegate: ObservationDetailProtocol) {
        taxaView.setup(taxon: taxon, delegate: delegate)
    }
}
