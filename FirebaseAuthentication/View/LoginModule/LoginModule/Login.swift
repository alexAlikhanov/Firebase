//
//  Login.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import UIKit
protocol LoginViewProtocol: AnyObject {
    
}

class Login: UIViewController {
    
   public var presenter: LoginPresenterProtocol?

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        
        if email.text != "", password.text != "" {
            let email = email.text!
            let pass = password.text!
            presenter?.logIn(withEmail: email, password: pass)
        } else {
            Util.shared.showAlert(withTitile: "Oops", massage: "Заполните пустые поля", viewController: self, complition: nil)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        presenter?.showSignIn()
    }
    
}
extension Login: LoginViewProtocol {
    
}
