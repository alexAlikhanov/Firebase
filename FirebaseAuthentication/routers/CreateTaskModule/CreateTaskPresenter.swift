//
//  CreatePresenter.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/27/22.
//

import Foundation
import UIKit

protocol CreateTaskPresenterProtocol{
    var view: CreateTaskProtocol? { get set }
    var router: RouterProtocol? { get set }
    var APIManager: APIManagerProtocol? { get set }
    var userDefaults: UserDefaultsManagerProtocol? { get set }
    init(view: CreateTaskProtocol, router: RouterProtocol, APIManager: APIManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol)
    func cancel()
    func save(title: String, subtitle: String)
}

class CreateTaskPresenter: CreateTaskPresenterProtocol {
    
    weak var view: CreateTaskProtocol?
    var router: RouterProtocol?
    var APIManager: APIManagerProtocol?
    var userDefaults: UserDefaultsManagerProtocol?
    
    required init(view: CreateTaskProtocol, router: RouterProtocol, APIManager: APIManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.view = view
        self.APIManager = APIManager
        self.userDefaults = userDefaultsManager
        self.router = router
    }
    func save(title: String, subtitle: String) {
        guard let user = userDefaults?.getUser() else { return }
        let task = Task(title: title, subtitle: subtitle)
        APIManager?.createTask(forUser: user, task: task, complition: { result in
            switch result {
            case .failure(let error):
                Util.shared.showAlert(withTitile: "Oops", massage: "Ошибка создания задания: \(error.localizedDescription)", viewController: self.view as! UIViewController, complition: nil)
            case .success(_):
                self.router?.popToRoot()
            }
        })
    }
    func cancel() {
        Util.shared.showAlertWithCancel(withTitile: "Внимание!", massage: "Выйти без созранения?", viewController: view as! UIViewController) {
            self.router?.popToRoot()
        }
    }

}
