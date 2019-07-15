//
//  LoginRouter.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

final class LoginRouter: BaseRouter {
    
    func toMain() {
        let controller = UIStoryboard(name: "MainMenu", bundle: nil).instantiateViewController(MainViewController.self)
        setAsRoot(UINavigationController(rootViewController: controller))
    }
    
    func toRestore() {
        let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(RestorePasswordViewController.self)
        show(controller)
    }
    
    func toRegistration() {
        let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(RegistrationViewController.self)
        show(controller)
    }
    
}
