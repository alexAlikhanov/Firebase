//
//  Util.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/23/22.
//

import Foundation
import UIKit

class Util {
    
    static let shared = Util()
    
    func showAlert(withTitile title: String, massage: String, viewController: UIViewController, complition: ( () -> Void)?) -> Void {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "Ok", style: .default) { action in
            if let complition = complition {
                complition()
            }
        }
        
        alert.addAction(alertActionOk)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
