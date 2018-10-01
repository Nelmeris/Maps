//
//  UserRealmModel.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

class User: Object {
    
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    required convenience init(_ login: String, _ password: String) {
        self.init()
        
        self.login = login
        self.password = password
    }
    
    override static func primaryKey() -> String? {
        return "login"
    }
    
}
