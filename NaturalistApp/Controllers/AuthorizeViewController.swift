//
//  AuthorizeViewController.swift
//
//
//  Created by Dmitriy Borovikov on 10/12/2018.
//  Copyright © 2018 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

class AuthorizeViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.becomeFirstResponder()
        loginButton.backgroundColor = UIColor(named: "LoginButtonUnactiveBg")
        loginButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authSession()
    }
    
    private func authSession() {
        guard let bearer = KeychainService.shared[.bearer] else { return }
        NatProvider.shared.request(.apiToken(bearer: bearer))
            .then { (jwt: JWTToken) -> Promise<PagedResults<User>> in
                KeychainService.shared[.apiToken] = jwt.apiToken
                print(jwt.apiToken)
                return NatProvider.shared.request(.currentUser)
            }.done { (paged: PagedResults<User>) -> Void in
                let user = paged.results.content.first!
                print(user)
                self.performSegue(withIdentifier: "TabbarViewControllerSegue", sender: nil)
            }.catch { error in
                print(error)
        }
    }
    
    @IBAction func unwindToAuthorizeViewController(segue: UIStoryboardSegue) {
        KeychainService.shared[.bearer] = nil
        KeychainService.shared[.apiToken] = nil
    }

    @IBAction func loginButtonTap(_ sender: Any) {
        guard let login = usernameTextField.text,
            let password = passwordTextField.text,
            !login.isEmpty,
            !password.isEmpty else { return }
        
        let target = NatAPI.authorize(login: login, password: password)
        NatProvider.shared.request(target)
            .done {
                (result: AccessToken) -> Void in
                let bearer = result.accessToken
                KeychainService.shared[.bearer] = bearer
                self.authSession()
            }.catch { error in
                print(error)
        }
        

    }
    
    func keyboardDismiss() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keyboardDismiss()
    }
    
}


extension AuthorizeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var buttonOn = false
        switch textField {
        case usernameTextField:
            if !resultString.isEmpty && passwordTextField.text?.count != 0 {
                buttonOn = true
            }
        case passwordTextField:
            if !resultString.isEmpty && usernameTextField.text?.count != 0 {
                buttonOn = true
            }
        default:
            return true
        }
        
        loginButton.isEnabled = buttonOn
        loginButton.backgroundColor = UIColor(named: buttonOn ? "LoginButtonBg" : "LoginButtonUnactiveBg")

        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
                Animations.jiggle(view: textField as UIView)
                return false
        }
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            keyboardDismiss()
            loginButtonTap(textField)
        default:
            return false
        }
        return true
    }
}
