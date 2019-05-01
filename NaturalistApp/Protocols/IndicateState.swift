//
//  IndicateState.swift
//  CourseFinalTask
//
//  Created by Dmitriy Borovikov on 31/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

extension IndicateStateProtocol where Self: UIViewController {
    func startActivityIndicator(message: String? = nil) {
        if activityIndicator == nil {
            activityIndicator = GIFIndicator()
        }
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.frame = view.frame
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating(message: message)
    }
    
    func stopActivityIndicator() {
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func showAlert(error: Error, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: error.localizedDescription,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Dismiss", style: .default) { _ in
            completion?()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }

}
