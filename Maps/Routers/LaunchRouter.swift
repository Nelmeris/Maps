//
//  LaunchRouter.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

final class LaunchRouter: BaseRouter {
    
    func toMain() {
        perform(segue: "toMain")
    }
    
    func toLogin() {
        perform(segue: "toLogin")
    }
    
}
