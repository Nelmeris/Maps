//
//  LaunchViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "isAuth") || Date().timeIntervalSince1970 - UserDefaults.standard.double(forKey: "AuthDate") > 3600 {
            UserDefaults.standard.removeObject(forKey: "isAuth")
            UserDefaults.standard.removeObject(forKey: "UserNickname")
            UserDefaults.standard.removeObject(forKey: "AuthDate")
            performSegue(withIdentifier: "toLogin", sender: self)
        } else {
            performSegue(withIdentifier: "toMain", sender: self)
        }
    }
}
