/////
////  PhotoActivityIndicator.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Kingfisher

struct PhotoActivityIndicator: Indicator {
    let view: UIView
    
    func startAnimatingView() {
        let indicator = view as! UIActivityIndicatorView
        indicator.startAnimating()
    }
    func stopAnimatingView() {
        let indicator = view as! UIActivityIndicatorView
        indicator.stopAnimating()
    }
    
    init(style: UIActivityIndicatorView.Style) {
        view = UIActivityIndicatorView(style: style)
        view.backgroundColor = .black
    }
}
