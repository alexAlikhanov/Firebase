//
//  Login.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import UIKit
protocol LoginViewProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
}

class Login: UIViewController, LoginViewProtocol {
    
    public var presenter: LoginPresenterProtocol?
    private var validator = FieldValidator()

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.returnKeyType = .continue
        email.keyboardType = .emailAddress
        password.returnKeyType = .join
        email.delegate = self
        password.delegate = self
    }

    @IBAction func login(_ sender: Any) {
        
        guard validator.validateLoginTextFields(emailTF: email, passwordTF: password) else {
            Util.shared.showAlert(withTitile: "Oops", massage: "Заполните пустые поля", viewController: self, complition: nil)
            return
        }
            let email = email.text!
            let pass = password.text!
            presenter?.logIn(withEmail: email, password: pass)
    }
    
    @IBAction func signIn(_ sender: Any) {
        presenter?.showSignIn()
    }
    
}
extension Login: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case email:
            password.becomeFirstResponder()
        case password:
            password.resignFirstResponder()
            guard validator.validateLoginTextFields(emailTF: email, passwordTF: password) else {
                Util.shared.showAlert(withTitile: "Oops", massage: "Заполните пустые поля", viewController: self, complition: nil)
                break
            }
                let email = email.text!
                let pass = password.text!
                presenter?.logIn(withEmail: email, password: pass)
        default: break
            
        }
        return true
    }
}
