//
//  SignIn.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import UIKit


class SignIn: UIViewController, LoginViewProtocol {

    public var presenter: LoginPresenterProtocol?
    private var validator = FieldValidator()
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.returnKeyType = .continue
        email.returnKeyType = .continue
        password.returnKeyType = .go
        
        userName.delegate = self
        email.delegate = self
        password.delegate = self

    }

    @IBAction func signIn(_ sender: Any) {
        
        guard validator.validateSigninTextFields(userNAmeTF: userName, emailTF: email, passwordTF: password) else {
            Util.shared.showAlert(withTitile: "Oops", massage: "Заполните пустые поля", viewController: self, complition: nil)
            return
        }
        
        let email = email.text!
        let pass = password.text!
        let name = userName.text!
        presenter?.signIn(withEmail: email, password: pass, userName: name)
    }
}

extension SignIn: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userName:
            email.becomeFirstResponder()
        case email:
            password.becomeFirstResponder()
        case password:
            password.resignFirstResponder()
            guard validator.validateSigninTextFields(userNAmeTF: userName, emailTF: email, passwordTF: password) else {
                Util.shared.showAlert(withTitile: "Oops", massage: "Заполните пустые поля", viewController: self, complition: nil)
                break
            }
            
            let email = email.text!
            let pass = password.text!
            let name = userName.text!
            presenter?.signIn(withEmail: email, password: pass, userName: name)
        default: break
            
        }
        return true
    }
}

