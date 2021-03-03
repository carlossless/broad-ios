//
//  AppDelegate.swift
//  Broad
//
//  Created by Karolis Stasaitis on 06/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveSwift
import CoreSpotlight
import SwiftUI

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigator: Navigator!
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        setAppCenter()
        setupAudioSessionCategory()
        
        navigator = Navigator.shared
        registerViewControllers()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        navigator.window = window
        window?.rootViewController = UIHostingController(rootView: SwiftUISelectionView())
//        navigator.replaceRoot(model: SplashViewModel())
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        guard let vc = (window?.rootViewController?.presentedViewController) else {
            return .portrait
        }
        
        if vc.isKind(of: NSClassFromString("AVFullScreenViewController")!) {
            return .allButUpsideDown
        }
        
        return .portrait
    }
    
    private func registerViewControllers() {
        navigator.register(SplashViewController.self, for: SplashViewModel.self)
        navigator.register(SelectionNavigationController.self, for: SelectionViewModel.self)
        navigator.register(AboutViewController.self, for: AboutViewModel.self)
        navigator.register(ChannelViewController.self, for: ChannelViewModel.self)
        navigator.register(ProgrammeViewController.self, for: ProgrammeViewModel.self)
    }
    
    private func setAppCenter() {
        AppCenter.start(withAppSecret: Secrets.AppCenterKey, services:[
          Analytics.self,
          Crashes.self
        ])
    }
    
    private func setupAudioSessionCategory() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed setting AVAudioSessionCategoryPlayback")
        }
    }

}
