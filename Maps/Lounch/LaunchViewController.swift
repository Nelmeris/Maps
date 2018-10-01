//
//  LaunchViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var router: LaunchRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Authorization.shared.isAuth {
            router.toMain()
        } else {
            router.toLogin()
        }
    }
    
}
