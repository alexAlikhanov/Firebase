//
//  MainPresenter.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import Foundation
import UIKit
import CoreAudio

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
    func deleteTask(for index: Int)
    func showDetail(forTask: Task)
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
        APIManager?.getTasks(document: "", complition: { [weak self] tasks in
            guard let tasks = tasks else {
                return
            }
            self?.tasks = tasks
            self?.view?.updateTableViewData()
        })
    }
    func createTask() {
        
        let alert = UIAlertController(title: "Новая заметка", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Введите имя"
        }
        let create = UIAlertAction(title: "Создать", style: .default) { [weak self] action in
            guard let title = alert.textFields?.first?.text, alert.textFields?.first?.text != "" else { return }
            let task = Task(id: "", title: title, subtitle: "", body: "")
            self?.APIManager?.createTask(task: task, complition: { [weak self] result in
                switch result {
                case .success(_): self?.mainViewLoaded()
                case .failure(_): print("error")
                }
            })
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(create)
        let view = view as! UIViewController
        view.present(alert, animated: true, completion: nil)
    }
    
    func deleteTask(for index: Int) {
        guard let id = self.tasks?[index].id else { return }
        self.tasks?.remove(at: index)
        APIManager?.removeTask(documentId: id, complition: { result in
            print(result)
        })
    }
    
    func showDetail(forTask: Task) {
        router?.presentDetailFor(task: forTask)
    }
}
