//
//  AppDelegate.swift
//  Maps
//
//  Created by Artem Kufaev on 25/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyApJcMOnEjjeQzYz2255SQAuEg-TrLlMNE")
        
        let controller: UIViewController
        if Authorization.shared.isAuth {
            controller = UIStoryboard(name: "MainMenu", bundle: nil).instantiateViewController(MainViewController.self)
        } else {
            controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(LoginViewController.self)
        }
        
        window = UIWindow()
        
        window?.rootViewController = UINavigationController(rootViewController: controller)
        
        window?.makeKeyAndVisible()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            
            self.sendNotificationRequest(
                content: self.makeNotificationContent(),
                trigger: self.makeIntervalNotificationTrigger()
            )
        }
        
        return true
    }
    
    /// View эффекта блюра
    var blurEffectView: UIVisualEffectView?
    
    /// Убрать защитную шторку при открытии приложения
    func applicationDidBecomeActive(_ application: UIApplication) {
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }
    
    /// Установить защитную шторку при сворачивании приложения
    func applicationWillResignActive(_ application: UIApplication) {
        guard let view = window?.rootViewController?.view else { return }
        self.blurEffectView = getBlurEffectView(view)
        window?.rootViewController?.view.addSubview(self.blurEffectView!)
    }
    
    func getBlurEffectView(_ view: UIView) -> UIVisualEffectView {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Мы вас потеряли!"
        content.body = "Вы свернули приложение и не закрыли его, вы не забыли про нас? Закройте приложение, чтобы мы не тратили ваши ресурсы!"
        content.badge = 1
        return content
    }
    
    func makeIntervalNotificationTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 1800, repeats: false)
    }
    
    func sendNotificationRequest(
        content: UNNotificationContent,
        trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["alarm"])
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        center.getDeliveredNotifications { notifications in
            print("\n\n\n\n")
            for notification in notifications {
                print("\n\n\n\n")
            }
        }
    }

}
