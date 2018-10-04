//
//  Authorization.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation

class Authorization {
    
    public static let shared = Authorization()
    private init() { }
    
    private let authTime = 3600.0 // 1 час
    
    var isAuth: Bool {
        if UserDefaults.standard.bool(forKey: "isAuth") &&
            Date().timeIntervalSince1970 - UserDefaults.standard.double(forKey: "AuthDate") > authTime {
            logout()
        }
        return UserDefaults.standard.bool(forKey: "isAuth")
    }
    
    var userName: String? {
        return UserDefaults.standard.string(forKey: "UserNickname")
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isAuth")
        UserDefaults.standard.removeObject(forKey: "UserNickname")
        UserDefaults.standard.removeObject(forKey: "AuthDate")
    }
    
    func login(user: UserRealmModel) {
        UserDefaults.standard.set(true, forKey: "isAuth")
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "AuthDate")
        UserDefaults.standard.set(user.login, forKey: "UserNickname")
    }
    
}
