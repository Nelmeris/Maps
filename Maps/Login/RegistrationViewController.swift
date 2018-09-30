//
//  RegistrationViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

class RegistrationViewController: UIViewController {
    @IBOutlet weak var loginBox: UIView!
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    override func viewDidLoad() {
        loginBox.layer.cornerRadius = 8
    }
    
    @IBAction func registration(_ sender: Any) {
        // Проверка на полноту введенных данных
        guard let login = loginField.text, login != "",
            let password = passwordField.text, password != "",
            let repeatPassword = repeatPasswordField.text, repeatPassword != ""
            else {
                let alert = UIAlertController(title: "Ошибка", message: "Введите все данные!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        // Проверка совпадения паролей
        guard password == repeatPassword else {
            let alert = UIAlertController(title: "Ошибка", message: "Пароли не совпадают!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        do {
            let realm = try Realm()
            
            // Проверка свободности логина
            let users = realm.objects(User.self)
            for user in users {
                guard login != user.login else {
                    let alert = UIAlertController(title: "Ошибка", message: "Пользователь уже существует!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            // Создание нового пользователя
            let newUser = User(login: login, password: password)
            realm.beginWrite()
            realm.add(newUser)
            try realm.commitWrite()
            let alert = UIAlertController(title: "Успешно!", message: "Вы успешно зарегистрировались", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.performSegue(withIdentifier: "back", sender: self)
            })
            self.present(alert, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
}
