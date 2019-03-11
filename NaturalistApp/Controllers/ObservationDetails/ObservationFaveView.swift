//
//  ObservationFaveView.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ObservationFaveView: UIView, NibInstantiable {
    @IBOutlet weak var favoritedLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    weak var delegate: ObservationDetailProtocol?
    
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
    func setup(observation: Observation, delegate: ObservationDetailProtocol) {
        self.delegate = delegate
        favoritedLabel.text = "Favored: " + String(observation.favesCount)
        favedByMe = observation.favedByMe
    }
}
