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
    @IBOutlet weak var loginBox: UIView!
    
    @IBOutlet weak var loginField: UITextField!
    
    override func viewDidLoad() {
        loginBox.layer.cornerRadius = 8
    }
    
    @IBAction func restorePassword(_ sender: Any) {
        guard let login = loginField.text, login != "" else {
            let alert = UIAlertController(title: "Ошибка", message: "Введите логин!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        do {
            let realm = try Realm()
            let users = realm.objects(User.self)
            for user in users {
                if user.login == login {
                    // При нахождении пользователя
                    // Выдать пароль
                    let alert = UIAlertController(title: "Ваши данные",
                                                  message: "Логин: \(login)\nПароль: \(user.password)",
                        preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.performSegue(withIdentifier: "back", sender: self)
                    })
                    self.present(alert, animated: true, completion: nil)
                    // Вернуться на страницу входа
                    return
                }
            }
            // При отсутствии пользователя в базе
            let alert = UIAlertController(title: "Ошибка", message: "Пользователь не найден", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
}
