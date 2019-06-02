/////
////  ObservationFaveTableViewCell.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ObservationFaveTableViewCell: UITableViewCell {
    @IBOutlet weak var favoritedLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    weak var delegate: (FaveChangeProtocol & ObservationDetailProtocol)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let starRecognizer = UITapGestureRecognizer(target: self, action: #selector(faveChange))
        starImageView.addGestureRecognizer(starRecognizer)
        let labelRecognizer = UITapGestureRecognizer(target: self, action: #selector(showFavedUsers))
        favoritedLabel.addGestureRecognizer(labelRecognizer)
    }
    
    @objc func faveChange() {
        delegate?.faveChange()
    }
    
    @objc func showFavedUsers() {
        delegate?.showFavedUsers()
    }
    
    var favedByMe: Bool = false {
        didSet {
            starImageView.image = UIImage(named: favedByMe ? "IC Star 24px" : "IC Star Border 24px")
        }
    }
    
    func setup(observation: Observation, delegate: (FaveChangeProtocol & ObservationDetailProtocol)) {
        self.delegate = delegate
        favoritedLabel.text = NSLocalizedString("Favored: ", comment: "") + String(observation.favesCount)
        favedByMe = observation.favedByMe
    }
}
