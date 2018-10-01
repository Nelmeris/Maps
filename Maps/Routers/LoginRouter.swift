//
//  LoginRouter.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

final class LoginRouter: BaseRouter {
    
    func toLounch() {
        perform(segue: "toLounch")
    }
    
    func toRestore() {
        perform(segue: "toRestore")
    }
    
    func toRegistration() {
        perform(segue: "toRegistration")
    }
    
}
