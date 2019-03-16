//
//  PhotoActivityIndicator.swift
//  PhotoViewController
//
//  Created by Dmitriy Borovikov on 16/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

struct PhotoActivityIndicator: Indicator {
    let view: UIView = UIActivityIndicatorView(style: .whiteLarge)
    
    func startAnimatingView() {
        let indicator = view as! UIActivityIndicatorView
        indicator.startAnimating()
    }
    func stopAnimatingView() {
        let indicator = view as! UIActivityIndicatorView
        indicator.stopAnimating()
    }
    
    init() {
        view.backgroundColor = .black
    }
}
