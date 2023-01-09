//
//  SignIn.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import UIKit


class SignIn: UIViewController {

    public var presenter: LoginPresenterProtocol?
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signIn(_ sender: Any) {
        
        if email.text != "", password.text != "", userName.text != ""  {
            let email = email.text!
            let pass = password.text!
            let name = userName.text!
            
            presenter?.signIn(withEmail: email, password: pass, userName: name)
        } else {
            Util.shared.showAlert(withTitile: "Oops", massage: "Заполните пустые поля", viewController: self, complition: nil)
        }
    }
        
    
}
extension SignIn: LoginViewProtocol{
    
}
