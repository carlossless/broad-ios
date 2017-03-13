//
//  Navigator.swift
//  lrt
//
//  Created by Karolis Stasaitis on 31/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

class Navigator {
    
    var window: UIWindow? {
        get {
            return actuator.window
        }
        set {
            actuator.window = newValue
        }
    }
    let actuator: NavigationActuator
    var vcMap: [String : UIViewController.Type] = [:]
    
    static let shared = Navigator()
    
    init() {
        self.actuator = NavigationActuator()
    }
    
    func register(_ vcType: UIViewController.Type, for modelType: ViewModel.Type) {
        vcMap[String(describing: modelType)] = vcType
    }
    
    func resolveAndConfigureController(for model: ViewModel) -> UIViewController {
        let vcClass = vcMap[String(describing: type(of: model))]!
        let vc = vcClass.init()
        if let mb = vc as? AnyModelBased {
            mb.configureAny(for: model)
        }
        return vc
    }
    
    func replaceRoot(model: ViewModel, animated: Bool = false, options: UIViewAnimationOptions = []) {
        actuator.replaceRoot(vc: resolveAndConfigureController(for: model), animated: animated, options: options)
    }
    
    func push(model: ViewModel, animated: Bool) {
        actuator.push(vc: resolveAndConfigureController(for: model), animated: animated)
    }
    
    func present(model: ViewModel, animated: Bool) {
        actuator.present(vc: resolveAndConfigureController(for: model), animated: animated)
    }
    
    func pop(animated: Bool) {
        actuator.pop(animated: animated)
    }
    
    func dismiss(animated: Bool) {
        actuator.pop(animated: animated)
    }
    
}

class NavigationActuator {
    
    var window: UIWindow?
    
    func replaceRoot(vc: UIViewController, animated: Bool, options: UIViewAnimationOptions) {
        let replaceAction: (Bool) -> Void = { _ in
            self.window!.rootViewController = vc
        }
        if animated && window!.rootViewController != nil {
            UIView.transition(
                from: window!.rootViewController!.view!,
                to: vc.view,
                duration: 1.0,
                options: options,
                completion: replaceAction
            )
        } else {
            replaceAction(true)
        }
    }
    
    func push(vc: UIViewController, animated: Bool) {
        if let nav = window?.topMostViewController?.navigationController {
            nav.pushViewController(nav, animated: animated)
        } else {
            print("Couldn't find a navigation controller")
        }
    }
    
    func present(vc: UIViewController, animated: Bool) {
        if let vc = window?.topMostViewController {
            vc.present(vc, animated: animated, completion: nil)
        } else {
            print("Couldn't find a view controller")
        }
    }
    
    func pop(animated: Bool) {
        if let nav = window?.topMostViewController?.navigationController {
            nav.popViewController(animated: animated)
        } else {
            print("Couldn't find a navigation controller")
        }
    }
    
    func dismiss(animated: Bool) {
        if let presenting = window?.topMostViewController?.presentingViewController {
            presenting.dismiss(animated: true, completion: nil)
        } else {
            print("Couldn't find a presenting view controller")
        }
    }
    
}

extension UIWindow {

    var topMostViewController: UIViewController? {
        if let windowRootViewController = self.rootViewController {
            return windowRootViewController.topMostDescendantViewController
        }
        return nil
    }
    
}

extension UIViewController {
    
    var topMostDescendantViewController: UIViewController? {
        
        if let tabBarController = self as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController.topMostDescendantViewController
        }
        
        if let navigationController = self as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return visibleViewController.topMostDescendantViewController
        }
        
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostDescendantViewController
        }
        
        for subview in self.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return childViewController.topMostDescendantViewController
            }
        }
        
        return self
    }
    
}
