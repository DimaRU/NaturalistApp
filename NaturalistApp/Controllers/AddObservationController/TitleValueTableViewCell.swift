/////
////  TitleValueTableViewCell.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class TitleValueTableViewCell: UITableViewCell {
    public var titleLabel: UILabel? {
        return viewWithTag(1) as? UILabel
    }
    public var valueLabel: UILabel? {
        return viewWithTag(2) as? UILabel
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


}
