//
//  UIViewController+TopMost.swift
//  Cart
//
//  Created by Karolis Stasaitis on 14/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit

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
