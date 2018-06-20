//
//  UIWindow+TopMost.swift
//  Cart
//
//  Created by Karolis Stasaitis on 14/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    var topMostViewController: UIViewController? {
        if let windowRootViewController = self.rootViewController {
            return windowRootViewController.topMostDescendantViewController
        }
        return nil
    }
    
}
