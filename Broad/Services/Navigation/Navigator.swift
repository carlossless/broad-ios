//
//  Navigator.swift
//  Broad
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
    private let actuator: NavigationActuator
    private var vcMap: [String : UIViewController.Type] = [:]
    
    static let shared = Navigator()
    
    init() {
        self.actuator = NavigationActuator()
    }
    
    func register(_ vcType: UIViewController.Type, for modelType: ViewModel.Type) {
        vcMap[String(describing: modelType)] = vcType
    }
    
    private func resolveAndConfigureController(for model: ViewModel) -> UIViewController {
        let vcClass = vcMap[String(describing: type(of: model))]!
        let vc = vcClass.init()
        if let mb = vc as? AnyModelBased {
            mb.configureAny(for: model)
        }
        return vc
    }
    
    func replaceRoot(model: ViewModel, animated: Bool = false, options: UIViewAnimationOptions = []) {
        actuator.replaceRoot(controller: resolveAndConfigureController(for: model), animated: animated, options: options)
    }
    
    func push(model: ViewModel, animated: Bool) {
        actuator.push(controller: resolveAndConfigureController(for: model), animated: animated)
    }
    
    func present(model: ViewModel, animated: Bool) {
        actuator.present(controller: resolveAndConfigureController(for: model), animated: animated)
    }
    
    func pop(animated: Bool) {
        actuator.pop(animated: animated)
    }
    
    func dismiss(animated: Bool) {
        actuator.pop(animated: animated)
    }
    
}

private class NavigationActuator {
    
    var window: UIWindow?
    
    func replaceRoot(controller: UIViewController, animated: Bool, options: UIViewAnimationOptions) {
        let snapshot = self.window!.snapshotView(afterScreenUpdates: true)!
        controller.view.addSubview(snapshot)
        
        self.window!.rootViewController = controller
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: { _ in
            snapshot.removeFromSuperview()
        })
    }
    
    func push(controller target: UIViewController, animated: Bool) {
        if let nav = window?.topMostViewController?.navigationController {
            nav.pushViewController(target, animated: animated)
        } else {
            print("Couldn't find a navigation controller")
        }
    }
    
    func present(controller target: UIViewController, animated: Bool) {
        if let controller = window?.topMostViewController {
            controller.present(target, animated: animated, completion: nil)
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
            presenting.dismiss(animated: animated, completion: nil)
        } else {
            print("Couldn't find a presenting view controller")
        }
    }
    
}
