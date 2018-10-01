//
//  MainRouter.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

final class MainRouter: BaseRouter {
    
    func toMap() {
        perform(segue: "toMap")
    }
    
    func toLogin() {
        perform(segue: "toLogin")
    }
    
}
