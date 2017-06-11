//
//  UIColor+Hex.swift
//  lrt
//
//  Created by Karolis Stasaitis on 29/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import CoreGraphics

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, alphaValue: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alphaValue)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, alphaValue: alpha)
    }
    
}
