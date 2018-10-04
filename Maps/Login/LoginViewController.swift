//
//  LoginViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet var router: LoginRouter!
    
    @IBOutlet weak var loginBox: UIView! {
        didSet {
            loginBox.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable
            .combineLatest(
                self.loginField.rx.text,
                self.passwordField.rx.text
            )
            .map { login, password in
                return (login ?? "").count >= 3 && (password ?? "").count >= 8
            }
            .bind { [weak loginButton] inputFilled in
                loginButton?.isEnabled = inputFilled
                loginButton?.setTitleColor(inputFilled ? .white : .gray, for: UIControl.State(rawValue: 0))
            }
    }
    
    @IBAction func login(_ sender: Any) {
        let login = loginField.text!
        let password = passwordField.text!
        
        // При отсутствии пользователя в базе
        guard RealmService.shared.isInRealm(login) else {
            let alert = UIAlertController(title: "Ошибка", message: "Пользователь не найден", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // При ошибке в пароле
        guard RealmService.shared.isValidate(login, password) else {
            let alert = UIAlertController(title: "Ошибка", message: "Неверный пароль!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // При удаче сохранить аутентификацию и вернуться на страницу авторизации
        let user = UserRealmModel(login, password)
        Authorization.shared.login(user: user)
        router.toMain()
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
