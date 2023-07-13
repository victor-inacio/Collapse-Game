//
//  AppDelegate.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
        
        window = UIWindow()
        
        window?.rootViewController = GameViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
}


