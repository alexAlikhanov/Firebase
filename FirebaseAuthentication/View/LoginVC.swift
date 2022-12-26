//
//  ViewController.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/23/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func auth(){
        if emailTextField.text != "", passwordTextField.text != "" {
            let email = emailTextField.text!
            let pass = passwordTextField.text!
            Auth.auth().signIn(withEmail: email, password: pass) { result, error in
                if error != nil {
                    Util.shared.showAlert(withTitile: "Oops", massage: error!.localizedDescription, viewController: self, complition: nil)
                } else {
                    APIManager.shared.currentUser = result
                    Util.shared.showAlert(withTitile: "Success", massage: "You are singing" + (result?.user.uid)!, viewController: self) {
                        self.dismiss(animated: true, completion: nil)
                        let vc = ViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        
        auth()
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
    }
}

