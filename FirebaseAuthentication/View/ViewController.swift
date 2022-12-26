//
//  ViewController.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titles: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titles.text = APIManager.shared.currentUser.user.email
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        
        APIManager.shared.setPost(collection: "Users", document: "test") {
            
        }
    }
}
