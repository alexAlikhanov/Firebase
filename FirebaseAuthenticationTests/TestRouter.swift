//
//  TestRouser.swift
//  FirebaseAuthenticationTests
//
//  Created by Алексей on 07.02.2023.
//

import XCTest
@testable import FirebaseAuthentication

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    var isDismiss: Bool = false
    var isPopToRoot: Bool = false
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.isDismiss = true
        super.dismiss(animated: flag, completion: completion)
    }
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        self.isPopToRoot = true
        return super.popToRootViewController(animated: animated)
    }
}

class MockUserDefaultsManager: UserDefaultsManagerProtocol {
    var isHaveUser: Bool = false
    var setUpUser: String!
    func getUser() -> String? {
        if isHaveUser { return " boo"} else { return nil }
    }
    
    func setUser(uid: String?) {
        self.setUpUser = uid
    }
}

final class TestRouter: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    var assembly = AssemblyModuleBuilder()
    var apiManager = APIManager()
    var userDefaultsManager = MockUserDefaultsManager()

    override func setUpWithError() throws {
        
        router = Router(navigationController: navigationController, assemblyBuilder: assembly, APIManager: apiManager, userDefaultManager: userDefaultsManager)
    }

    override func tearDownWithError() throws {
       router = nil
    }
    
    func testPresentSignIn() {
        router.presentSignIn()
        let signInVC = navigationController.presentedVC
        XCTAssertTrue(signInVC is SignIn)
    }
    func testPresentDetailFor() {
        router.presentDetailFor(task: Task(id: "boo", title: "baz", subtitle: "bar", body: "boz"))
        let detailVC = navigationController.presentedVC
        XCTAssertTrue(detailVC is DetailTaskController)
    }
    func testDismiss() {
        router.dismiss(complition: nil)
        let isDismiss = navigationController.isDismiss
        XCTAssertTrue(isDismiss)
    }
    func testPopToRoot() {
        router.popToRoot()
        let isPopToRoot = navigationController.isPopToRoot
        XCTAssertTrue(isPopToRoot)
    }
    func testInitialViewController() {
        router.initialViewController()
        let loginVC = navigationController.viewControllers[0]
        XCTAssertTrue(loginVC is Login)
    
        userDefaultsManager.isHaveUser = true
        router.initialViewController()
        let mainVC = navigationController.viewControllers[0]
        XCTAssertTrue(mainVC is MainViewController2)
    }

}
