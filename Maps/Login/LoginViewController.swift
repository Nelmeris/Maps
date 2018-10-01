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
    
    @IBOutlet var router: LoginRouter!
    
    @IBOutlet weak var loginBox: UIView! {
        didSet {
            loginBox.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
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
        if RealmService.shared.isInRealm(login) {
            if RealmService.shared.isValidate(login, password) {
                // При удаче сохранить аутентификацию
                let user = User(login, password)
                Authorization.shared.login(user: user)
                // Перейти на главную страницу
                router.toMain()
            } else {
                // При ошибке в пароле
                let alert = UIAlertController(title: "Ошибка", message: "Неверный пароль!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Пользователь не найден", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func restorePassword(_ sender: Any) {
        // Перейти на страницу восстановления
        router.toRestore()
    }
    
    @IBAction func registration(_ sender: Any) {
        // Перейти на страницу регистрации
        router.toRegistration()
    }
    
}
