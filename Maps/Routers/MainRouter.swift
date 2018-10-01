//
//  MainRouter.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

final class MainRouter: BaseRouter {
    
    func toMap() {
        let controller = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(MapViewController.self)
        show(controller)
    }
    
    func toLogin() {
        let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(LoginViewController.self)
        setAsRoot(UINavigationController(rootViewController: controller))
    }
    
}
