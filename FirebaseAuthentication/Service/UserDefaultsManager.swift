//
//  UserDefaultsManager.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/23/22.
//

import Foundation

protocol UserDefaultsManagerProtocol{
    func getUser() -> String?
    func setUser(uid: String?) -> Void
}

class UserDefaultsManager: UserDefaultsManagerProtocol {

    static var shared = UserDefaultsManager()
    
    func getUser() -> String? {
        guard let userUID = UserDefaults.standard.string(forKey: "currentUser") else { return nil }
        return userUID
    }
    
    func setUser(uid: String?) {
        UserDefaults.standard.set(uid, forKey: "currentUser")
    }
}
