//
//  AppDelegate.swift
//  lrt
//
//  Created by Karolis Stasaitis on 06/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import UIKit
import HockeySDK
import AVFoundation

import Fuzi
import ReactiveSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigator: Navigator!
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        setupHockeyApp()
        setupAudioSessionCategory()
        
        navigator = Navigator.shared
        registerViewControllers()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigator.window = window
        navigator.replaceRoot(model: SplashViewModel())
        window?.makeKeyAndVisible()
    }
    
    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: "58d1c2e2eaf14e97b01973edade2d378")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }
    
    private func registerViewControllers() {
        navigator.register(SplashViewController.self, for: SplashViewModel.self)
        navigator.register(SelectionNavigationController.self, for: MainViewModel.self)
        navigator.register(PlayerViewController.self, for: PlayerViewModel.self)
    }
    
    private func setupAudioSessionCategory() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed setting AVAudioSessionCategoryPlayback")
        }
    }

}
