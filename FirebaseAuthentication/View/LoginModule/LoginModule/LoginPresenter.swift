//
//  LoginPresenter.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import Foundation
import UIKit

protocol LoginPresenterProtocol{
    init(view: LoginViewProtocol, router: RouterProtocol, APIManager: APIManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol)
    func logIn(withEmail email: String, password: String) -> Void
    func signIn(withEmail email: String, password: String, userName: String) -> Void
    func showSignIn()
}

class LoginPresenter: LoginPresenterProtocol {
   weak var view: LoginViewProtocol?
    var router: RouterProtocol?
    var APIManager: APIManagerProtocol?
    var userDefaults: UserDefaultsManagerProtocol?
    
    required init(view: LoginViewProtocol, router: RouterProtocol, APIManager: APIManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        
        self.view = view
        self.router = router
        self.APIManager = APIManager
        self.userDefaults = userDefaultsManager
    }
    
    func logIn(withEmail email: String, password: String) {
        APIManager?.login(withEmail: email, password: password, complition: { [weak self] result in
            switch result {
            case .failure(let error):
                Util.shared.showAlert(withTitile: "Oops", massage: error.localizedDescription, viewController: self?.view as! UIViewController, complition: nil)
            case .success(let UID):
                self?.userDefaults?.setUser(uid: UID!)
                self?.router?.initialViewController()
            }
        })
    }
    
    func signIn(withEmail email: String, password: String, userName: String) {
        
        APIManager?.signIn(withEmail: email, password: password, userName: userName, complition: { [weak self] result in
            switch result {
            case .failure(let error):
                Util.shared.showAlert(withTitile: "Oops", massage: error.localizedDescription, viewController: self?.view as! UIViewController, complition: nil)
            case .success(_):
                Util.shared.showAlert(withTitile: "Success", massage: "You are registrated!", viewController: self?.view as! UIViewController) {
                    self?.logIn(withEmail: email, password: password)
                    self?.router?.dismiss(complition: nil)
                }
            }
        })
    }
    
    func showSignIn() {
        router?.presentSignIn()
    }
    
}
