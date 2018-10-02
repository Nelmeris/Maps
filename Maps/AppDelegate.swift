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
        
        return true
    }
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        blurEffectView.alpha = 0
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let view = window?.rootViewController?.view
        blurEffectView.frame = (view?.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1
        view?.addSubview(blurEffectView)
    }

}
