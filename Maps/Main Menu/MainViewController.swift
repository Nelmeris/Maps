//
//  MainViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var router: MainRouter!
    
    @IBOutlet weak var mainBox: UIView! {
        didSet {
            mainBox.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var helloLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userName = Authorization.shared.userName else { fatalError() }
        helloLabel.text = "Добро пожаловать, \(userName)"
    }
    
    @IBAction func openMap(_ sender: Any) {
        router.toMap()
    }
    
    @IBAction func logout(_ sender: Any) {
        Authorization.shared.logout()
        router.toLogin()
    }

}
