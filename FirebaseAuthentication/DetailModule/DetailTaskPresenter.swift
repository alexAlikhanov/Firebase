//
//  DetailTaskPresenter.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 1/9/23.
//

import Foundation

protocol DetailTaskPresenterProtocol{
    var view: DetailTaskProtocol? { get set }
    var task: Task? { get set }
    var router: RouterProtocol? { get set }
    var APIManager: APIManagerProtocol? { get set }
    init(task: Task, view: DetailTaskProtocol, router: RouterProtocol, APIManager: APIManagerProtocol)
    func viewLoaded()
    func save(bodyText: String)
}

class DetailTaskPresenter: DetailTaskPresenterProtocol {

    weak var view: DetailTaskProtocol?
    var router: RouterProtocol?
    var APIManager: APIManagerProtocol?
    var task: Task?
    
    required init(task: Task, view: DetailTaskProtocol, router: RouterProtocol, APIManager: APIManagerProtocol) {
        self.view = view
        self.router = router
        self.APIManager = APIManager
        self.task = task
    }
    func viewLoaded() {
        guard let task = task else { return }
        view?.setup(task: task)
    }
    func save(bodyText: String) {
        guard var task = task else {
            return
        }
        task.subtitle = bodyText
        task.body = bodyText
        APIManager?.updateTask(task: task, complition: {[weak self] result in
            switch result {
            case .failure(_): self?.view?.feedback(isSave: false)
            case .success(_): self?.view?.feedback(isSave: true)
            }
        })
    }
}
