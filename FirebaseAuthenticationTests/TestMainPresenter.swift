//
//  TestMainPresenter.swift
//  FirebaseAuthenticationTests
//
//  Created by Алексей on 07.02.2023.
//

import XCTest
@testable import FirebaseAuthentication

class MockMainViewController: UIViewController, MainViewProtocol {
    var isUpdate: Bool = false
    var presentedVC: UIViewController!
    func updateTableViewData() {
        isUpdate = true
    }
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

class MockApiManager: APIManager {
    var removeID:String!
    override func getTasks(document: String, complition: @escaping ([FirebaseAuthentication.Task]?) -> Void) {
        let returnTask: [Task] = []
        complition(returnTask)
    }
    
    override func removeTask(documentId: String, complition: @escaping (Bool) -> Void) {
        removeID = documentId
        complition(true)
    }
    
    override func login(withEmail email: String, password: String, complition: @escaping (Result<String?, Error>) -> Void) {
        complition(.success(email + password))
    }
}

class MockRouter: Router {
    var deteilFor: Task!
    override func presentDetailFor(task: Task) {
        deteilFor = task
    }
}

final class TestMainPresenter: XCTestCase {
    
    var mainPresenter: MainViewPresenterProtocol!
    var view = MockMainViewController()
    var navigationController = MockNavigationController()
    var assembly = AssemblyModuleBuilder()
    var apiManager = MockApiManager()
    var userDefaultsManager = MockUserDefaultsManager()
    lazy var router = MockRouter(navigationController: navigationController, assemblyBuilder: assembly, APIManager: apiManager, userDefaultManager: userDefaultsManager)
    
    
    override func setUpWithError() throws {
        mainPresenter = MainPresenter(view: view, router: router, APIManager: apiManager, userDefaultsManager: userDefaultsManager)
    }

    override func tearDownWithError() throws {
        mainPresenter = nil
    }
    
    func testMainViewLoaded() {
        mainPresenter.mainViewLoaded()
        XCTAssertTrue(view.isUpdate)
    }
    func testCreateTask() {
        mainPresenter.createTask()
        let presentedVC = view.presentedVC
        XCTAssertTrue(presentedVC is UIAlertController)
    }
    func testDeleteTask() {
        let task = Task(id: "boo", title: "baz", subtitle: "bar", body: "boz")
        mainPresenter.tasks = [task]
        mainPresenter.deleteTask(for: 0)
        XCTAssertEqual(task.id, apiManager.removeID)
        let isEmpty = mainPresenter.tasks?.isEmpty
        XCTAssertTrue(isEmpty!)
    }
    func testShowDetailFor() {
        let task = Task(id: "boo", title: "baz", subtitle: "bar", body: "boz")
        mainPresenter.showDetail(forTask: task)
        let sentRouterTask = router.deteilFor!
        XCTAssertTrue(task.id == sentRouterTask.id)
        XCTAssertTrue(task.body == sentRouterTask.body)
        XCTAssertTrue(task.title == sentRouterTask.title)
        XCTAssertTrue(task.subtitle == sentRouterTask.subtitle)
    }
}
