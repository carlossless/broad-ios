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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigator: Navigator!
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        setupAudioSessionCategory()
        
        navigator = Navigator.shared
        registerViewControllers()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigator.window = window
        navigator.replaceRoot(model: SplashViewModel())
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Swift.Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            // This activity represents an item indexed using Core Spotlight, so restore the context related to the unique identifier.
            // Note that the unique identifier of the Core Spotlight item is set in the activity’s userInfo property for the key CSSearchableItemActivityIdentifier.
//            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                // Call the service
//            }
            // Next, find and open the item specified by uniqueIdentifer.
        }
        return true
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
    
    private func setupAudioSessionCategory() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed setting AVAudioSessionCategoryPlayback")
        }
    }

}
