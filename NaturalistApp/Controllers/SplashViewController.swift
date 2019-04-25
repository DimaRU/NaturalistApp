//
//  SplashViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 25/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

class SplashViewController: UIViewController {
    @IBOutlet weak var splashImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        splashImageView.animationFromGif(resource: "fish")
        splashImageView.animationDuration = 2
        splashImageView.startAnimating()
        authSession()
    }
    
    private func authSession() {
        authorizeSession()
            .done {
                self.splashImageView.stopAnimating()
                self.performSegue(withIdentifier: "TabbarViewControllerSegue", sender: nil)
            }.catch(on: nil, flags: nil, policy: .allErrors) { error in
                let loginViewController = LoginViewController.instantiate()
                if case PMKError.cancelled = error {
                } else {
                    print(error)
                    loginViewController.errorMessage = error.localizedDescription
                }
                self.present(loginViewController, animated: true)
        }
    }
    
    private func bearerPromise() -> Promise<String> {
        if let bearer = KeychainService.shared[.bearer] {
            return Promise.value(bearer)
        } else {
            return Promise(error: PMKError.cancelled)
        }
    }
}
