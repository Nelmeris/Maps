//
//  LoginViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var loginBox: UIView!
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        loginBox.layer.cornerRadius = 8
    }
    
    @IBAction func login(_ sender: Any) {
        guard let login = loginField.text, login != "",
            let password = passwordField.text, password != ""
            else {
                let alert = UIAlertController(title: "Ошибка", message: "Введите все данные!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        do {
            let realm = try Realm()
            let users = realm.objects(User.self)
            for user in users {
                if user.login == login {
                    if user.password == password {
                        // При удаче
                        // Сохранить аутентификацию
                        UserDefaults.standard.set(true, forKey: "isAuth")
                        // Сохранить время аутентификации (время дается на 1 час)
                        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "AuthDate")
                        
                        UserDefaults.standard.set(user.login, forKey: "UserNickname")
                        // Перейти на главную страницу
                        performSegue(withIdentifier: "toMain", sender: self)
                    } else {
                        // При ошибке в пароле
                        let alert = UIAlertController(title: "Ошибка", message: "Неверный пароль!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
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
    
    @IBAction func restorePassword(_ sender: Any) {
        // Перейти на страницу восстановления
        performSegue(withIdentifier: "toRestore", sender: self)
    }
    
    @IBAction func registration(_ sender: Any) {
        // Перейти на страницу регистрации
        performSegue(withIdentifier: "toRegistration", sender: self)
    }
    
    @IBAction func back(segue: UIStoryboardSegue) { }
}
