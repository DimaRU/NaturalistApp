/////
////  SplashViewController.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
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
    }

    override func viewDidAppear(_ animated: Bool) {
        authSession()
    }
    
    private func authSession() {
        authorizeSession()
            .done {
                self.performSegue(withIdentifier: "TabbarViewControllerSegue", sender: nil)
            }.ensure {
                self.splashImageView.stopAnimating()
            }.catch(on: nil, flags: nil, policy: .allErrors) { error in
                let loginViewController = LoginViewController.instantiate()
                if case PMKError.cancelled = error {
                } else {
                    print(error)
                    loginViewController.errorMessage = error.localizedDescription
                }
                loginViewController.delegate = self
                self.present(loginViewController, animated: false)
        }
    }

    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
        KeychainService.shared[.bearer] = nil
        KeychainService.shared[.apiToken] = nil
    }

}

extension SplashViewController: LoginViewControllerProtocol {
    func loggedIn() {
        self.performSegue(withIdentifier: "TabbarViewControllerSegue", sender: nil)
    }
}
