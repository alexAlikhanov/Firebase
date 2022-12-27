//
//  Router.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/22/22.
//

import Foundation
import UIKit

class Router: RouterProtocol {
    
    var userDefaultManager: UserDefaultsManagerProtocol?
    var APIManager: APIManagerProtocol!
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyModuleBuilderProtocol?

    required init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol, APIManager: APIManagerProtocol, userDefaultManager: UserDefaultsManagerProtocol) {
        self.APIManager = APIManager
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.userDefaultManager = userDefaultManager
    }

    
    func initialViewController() {
        if userDefaultManager?.getUser() != nil {
            if let navigationController = navigationController {
                guard let mainViewController = assemblyBuilder?.createMainModule(router: self, APIManager: APIManager) else {return}
                navigationController.viewControllers = [mainViewController]
            }
        } else {
            if let navigationController = navigationController {
                guard let mainViewController = assemblyBuilder?.createLoginModule(router: self, APIManager: APIManager) else {return}
                navigationController.viewControllers = [mainViewController]
            }
        }
    }
    
    func presentSignIn() {
        if let navigationController = navigationController {
            guard let ViewController = assemblyBuilder?.createSignInModule(router: self, APIManager: APIManager) else { return }
            
            ViewController.modalPresentationStyle = .formSheet
            navigationController.present(ViewController, animated: true)
        }
    }
    
    func presentCreateTask() {
        if let navigationController = navigationController {
            guard let ViewController = assemblyBuilder?.createTaskModule(router: self, APIManager: APIManager) else { return }
            ViewController.modalPresentationStyle = .automatic
            navigationController.pushViewController(ViewController, animated: true)
        }
    }

    func dismiss(complition: (() -> Void)?) {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true, completion: complition)
        }
    }
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

    
}
