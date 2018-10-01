//
//  BackToLoginRouter.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

final class BackToLoginRouter: BaseRouter {
    
    func toLogin() {
        let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(LoginViewController.self)
        show(controller)
    }
    
}
