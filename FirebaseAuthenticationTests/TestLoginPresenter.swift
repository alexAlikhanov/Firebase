//
//  TestLoginPresenter.swift
//  FirebaseAuthenticationTests
//
//  Created by Алексей on 08.02.2023.
//

import XCTest
@testable import FirebaseAuthentication


final class TestLoginPresenter: XCTestCase {
    var loginPresenter: LoginPresenterProtocol!
    var view = Login()
    var navigationController = MockNavigationController()
    var assembly = AssemblyModuleBuilder()
    var apiManager = MockApiManager()
    var userDefaults = MockUserDefaultsManager()
    lazy var router = Router(navigationController: navigationController , assemblyBuilder: assembly, APIManager: apiManager, userDefaultManager: userDefaults)
    
    override func setUpWithError() throws {
        loginPresenter = LoginPresenter(view: view, router: router, APIManager: apiManager, userDefaultsManager: userDefaults)
    }

    override func tearDownWithError() throws {
        loginPresenter = nil
    }

    func testLogIn(){
        let email = "Bar"
        let pass = "Baz"
        userDefaults.isHaveUser = true
        loginPresenter.logIn(withEmail: email, password: pass)
        let result = userDefaults.setUpUser ?? ""
        let result2 = navigationController.viewControllers[0]
        
        XCTAssertEqual((email + pass), result)
        XCTAssertTrue(result2 is MainViewController2)
    }
    
    func testShowSignIn() {
        loginPresenter.showSignIn()
        let result = navigationController.presentedVC
        XCTAssertTrue(result is SignIn)
    }
    
    
   

}
