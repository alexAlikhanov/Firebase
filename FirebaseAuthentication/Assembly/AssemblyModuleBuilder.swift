//
//  AssemblyModuleBuilder.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import UIKit

protocol AssemblyModuleBuilderProtocol{
    
    func createMainModule(router: RouterProtocol, APIManager: APIManagerProtocol) -> UIViewController
    func createLoginModule(router: RouterProtocol, APIManager: APIManagerProtocol) -> UIViewController
    func createSignInModule(router: RouterProtocol, APIManager: APIManagerProtocol) -> UIViewController
    func createTaskModule(router: RouterProtocol, APIManager: APIManagerProtocol) -> UIViewController
}


class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createMainModule(router: RouterProtocol, APIManager: APIManagerProtocol) -> UIViewController {
        let view = MainViewController2()
        let userDefaultsManager = UserDefaultsManager.shared
        let presenter = MainPresenter(view: view, router: router, APIManager: APIManager, userDefaultsManager: userDefaultsManager)
        view.presenter = presenter
        return view
    }
    
    func createLoginModule(router: RouterProtocol, APIManager: APIManagerProtocol) -> UIViewController {
        let view = Login()
        let userDefaultsManager = UserDefaultsManager.shared
        let presenter = LoginPresenter(view: view, router: router, APIManager: APIManager, userDefaultsManager: userDefaultsManager)
        view.presenter = presenter
        return view
    }
    
    func createSignInModule(router: RouterProtocol, APIManager: APIManagerProtocol) -> UIViewController {
        let view = SignIn()
        let userDefaultsManager = UserDefaultsManager.shared
        let presenter = LoginPresenter(view: view, router: router, APIManager: APIManager, userDefaultsManager: userDefaultsManager)
        view.presenter = presenter
        return view
    }
    
    func createTaskModule(router: RouterProtocol, APIManager: APIManagerProtocol) -> UIViewController {
        let view = CreateTaskController()
        let userDefaultsManager = UserDefaultsManager.shared
        let presenter = CreateTaskPresenter(view: view, router: router, APIManager: APIManager, userDefaultsManager: userDefaultsManager)
        view.presenter = presenter
        return view
    }

}
