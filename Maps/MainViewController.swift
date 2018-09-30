//
//  MainViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainBox: UIView!
    @IBOutlet weak var helloLabel: UITextView!
    
    override func viewDidLoad() {
        mainBox.layer.cornerRadius = 8
        guard let user = UserDefaults.standard.string(forKey: "UserNickname") else {
            fatalError()
        }
        helloLabel.text = "Добро пожаловать, \(user)"
    }
    
    @IBAction func openMap(_ sender: Any) {
        performSegue(withIdentifier: "toMap", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isAuth")
        UserDefaults.standard.removeObject(forKey: "UserNickname")
        UserDefaults.standard.removeObject(forKey: "AuthDate")
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
