//
//  AppDelegate.swift
//  lrt
//
//  Created by Karolis Stasaitis on 06/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigator: Navigator!
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        setupHockeyApp()
        
        navigator = Navigator.shared
        registerViewControllers()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        navigator.window = window
        navigator.replaceRoot(model: SplashViewModel())
        window.makeKeyAndVisible()
    }
    
    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: "58d1c2e2eaf14e97b01973edade2d378")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }
    
    private func registerViewControllers() {
        navigator.register(SplashViewController.self, for: SplashViewModel.self)
        navigator.register(SelectionNavigationController.self, for: MainViewModel.self)
    }

}
