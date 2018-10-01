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
    
    @IBOutlet var router: BackToLoginRouter!
    
    @IBOutlet weak var loginBox: UIView! {
        didSet {
            loginBox.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
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
            try RealmService.shared.createUser(login, password)
            let alert = UIAlertController(title: "Успешно!", message: "Вы успешно зарегистрировались", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.router.toLogin()
            })
            self.present(alert, animated: true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "Внимание!", message: "Пользователь уже существует! Изменить пароль?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
                try! RealmService.shared.changePassword(login, password)
                let alert = UIAlertController(title: "Успешно!", message: "Пароль был успешно изменен", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.router.toLogin()
                })
                self.present(alert, animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "Нет", style: .default) { _ in
                self.router.toLogin()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
