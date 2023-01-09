//
//  RouterProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import UIKit

protocol RouterMain{
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyModuleBuilderProtocol?  { get set }
    var APIManager: APIManagerProtocol! { get set }
    var userDefaultManager: UserDefaultsManagerProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol, APIManager: APIManagerProtocol, userDefaultManager: UserDefaultsManagerProtocol)
    func initialViewController()
    func presentSignIn()
    func presentDetailFor(task: Task)
    func popToRoot()
    func dismiss(complition: (()->Void)?)
} 
