//
//  SignInVC.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/23/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignInVC: UIViewController {

    @IBOutlet weak var nickTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    func singIn(){
        if emailTextField.text != "", passwordTextField.text != "" {
            let email = emailTextField.text!
            let pass = passwordTextField.text!
            let name = nickTextField.text!
            Auth.auth().createUser(withEmail: email, password: pass) { resault, error in
                if error != nil {
                    Util.shared.showAlert(withTitile: "Oops", massage: error!.localizedDescription, viewController: self, complition: nil)
                } else {
                    guard let result = resault else { return }
                    APIManager.shared.createUser(uid: result.user.uid, userName: name, email: email) { [weak self] in
                        guard let self = self else {return}
                            Util.shared.showAlert(withTitile: "Success", massage: "You are singing", viewController: self) {
                                self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }


    @IBAction func signInButton(_ sender: Any) {
        singIn()
    }
    
}
