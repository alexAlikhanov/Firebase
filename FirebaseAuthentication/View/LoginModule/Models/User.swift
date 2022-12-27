//
//  User.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import Foundation
import SwiftUI

public struct User: Codable {
    let userName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case userName
        case email
    }
}
