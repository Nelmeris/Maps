//
//  RegistrationViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    @IBOutlet weak var registrButton: UIButton!
    
    override func viewDidLoad() {
        Observable
            .combineLatest(
                self.loginField.rx.text,
                self.passwordField.rx.text,
                self.repeatPasswordField.rx.text
            )
            .map { login, password, repeatPassword in
                return (login ?? "").count >= 3 && (password ?? "").count >= 8 && password == repeatPassword
            }
            .bind { [weak registrButton] inputFilled in
                registrButton?.isEnabled = inputFilled
                registrButton?.titleLabel?.textColor = inputFilled ? .white : .gray
        }
    }
    
    @IBAction func registration(_ sender: Any) {
        let login = loginField.text!
        let password = passwordField.text!
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
