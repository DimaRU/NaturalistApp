//
//  IndicateState.swift
//  CourseFinalTask
//
//  Created by Dmitriy Borovikov on 31/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

extension IndicateStateProtocol where Self: UIViewController {
    func showActivityIndicator() {
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard !self.activityIndicator.isHidden else { return }
            self.activityIndicator.frame = self.view.frame
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func removeActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        if activityIndicator.superview != nil {
            activityIndicator.removeFromSuperview()
        }
    }
}
