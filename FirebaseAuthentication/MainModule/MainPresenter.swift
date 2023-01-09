//
//  MainPresenter.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import Foundation
import UIKit

protocol MainViewPresenterProtocol {
    var view: MainViewProtocol? { get set }
    var router: RouterProtocol? { get set }
    var APIManager: APIManagerProtocol? { get set }
    var userDefaults: UserDefaultsManagerProtocol? { get set }
    var tasks: [Task]? { get set }
    init(view: MainViewProtocol, router: RouterProtocol, APIManager: APIManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol)
    func logOut()
    func mainViewLoaded()
    func createTask()
}

class MainPresenter : MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    var APIManager: APIManagerProtocol?
    var userDefaults: UserDefaultsManagerProtocol?
    var tasks: [Task]? 
    
    required init(view: MainViewProtocol, router: RouterProtocol, APIManager: APIManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        
        self.view = view
        self.router = router
        self.APIManager = APIManager
        self.userDefaults = userDefaultsManager
    }
    
    func logOut() {
        Util.shared.showAlertWithCancel(withTitile: "Выход", massage: "Вы действительно хотите выйти из аккаута?", viewController: self.view as! UIViewController) { [weak self] in
            self?.APIManager?.logOut()
            self?.userDefaults?.setUser(uid: nil)
            self?.router?.initialViewController()
        }
    }
    func mainViewLoaded() {
        guard let user = userDefaults?.getUser() else { return }
        APIManager?.getTasks(forUser: user, document: "", complition: { [weak self] tasks in
            guard let tasks = tasks else {
                return
            }
            self?.tasks = tasks
            self?.view?.updateTableViewData()
        })
    }
    func createTask() {
        router?.presentCreateTask()
    }
}
