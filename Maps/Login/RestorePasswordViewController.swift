//
//  RestorePasswordViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class RestorePasswordViewController: UIViewController {
    
    @IBOutlet var router: BackToLoginRouter!
    
    @IBOutlet weak var loginBox: UIView! {
        didSet {
            loginBox.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginField.rx.text
            .map { login -> Bool in
                return (login?.count ?? 0) >= 3
            }
            .bind { [weak button] inputFilled in
                button?.isEnabled = inputFilled
                button?.setTitleColor(inputFilled ? .white : .gray, for: UIControl.State(rawValue: 0))
            }
    }
    
    @IBAction func restorePassword(_ sender: Any) {
        let login = loginField.text!
        
        // При отсутствии пользователя в базе
        guard let password = RealmService.shared.restorePassword(login) else {
            let alert = UIAlertController(title: "Ошибка", message: "Пользователь не найден", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // При нахождении пользователя выдать пароль
        let alert = UIAlertController(title: "Ваши данные",
                                      message: "Логин: \(login)\nПароль: \(password)",
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.router.toLogin()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}
