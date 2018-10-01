//
//  RestorePasswordViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

class RestorePasswordViewController: UIViewController {
    
    @IBOutlet var router: BackToLoginRouter!
    
    @IBOutlet weak var loginBox: UIView! {
        didSet {
            loginBox.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var loginField: UITextField!
    
    @IBAction func restorePassword(_ sender: Any) {
        guard let login = loginField.text, login != "" else {
            let alert = UIAlertController(title: "Ошибка", message: "Введите логин!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let password = RealmService.shared.restorePassword(login) {
            // При нахождении пользователя выдать пароль
            let alert = UIAlertController(title: "Ваши данные",
                                          message: "Логин: \(login)\nПароль: \(password)",
                preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.router.toLogin()
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            // При отсутствии пользователя в базе
            let alert = UIAlertController(title: "Ошибка", message: "Пользователь не найден", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
