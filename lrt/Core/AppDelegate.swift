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

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        setupHockeyApp()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.red
        window?.rootViewController = SelectionNavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()
    }
    
    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: "58d1c2e2eaf14e97b01973edade2d378")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }

}
