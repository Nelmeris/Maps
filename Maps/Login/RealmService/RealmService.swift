//
//  RealmService.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init() { }
    public static let shared = RealmService()
    
    enum AuthorizationErrors: Error {
        case nonExistentUser, preExistentUser
    }
    
    private func getUser(_ nickname: String) -> User? {
        do {
            let realm = try Realm()
            let users = realm.objects(User.self)
            
            for user in users {
                if user.login.lowercased() == nickname.lowercased() {
                    return user
                }
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    /// Регистрация нового пользователя
    func createUser(_ nickname: String, _ password: String) throws {
        if getUser(nickname) == nil {
            let user = User(nickname, password)
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(user)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        } else {
            throw AuthorizationErrors.preExistentUser
        }
    }
    
    /// Изменение пароля
    func changePassword(_ nickname: String, _ password: String) throws {
        if let user = getUser(nickname) {
            do {
                let realm = try Realm()
                realm.beginWrite()
                user.password = password
                try realm.commitWrite()
            } catch {
                print(error)
            }
        } else {
            throw AuthorizationErrors.nonExistentUser
        }
    }
    
    /// Восстановление пароля
    func restorePassword(_ nickname: String) -> String? {
        let user = getUser(nickname)
        return user?.password
    }
    
    /// Нахождение пользователя в базе
    func isInRealm(_ nickname: String) -> Bool {
        return getUser(nickname) != nil
    }
    
    /// Правильность введенных данных
    func isValidate(_ nickname: String, _ password: String) -> Bool {
        guard let user = getUser(nickname),
            isInRealm(nickname) else {
                return false
        }
        
        return user.password == password
        
    }
    
}
