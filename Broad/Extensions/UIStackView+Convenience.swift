//
//  UIStackView+Convenience.swift
//  Broad
//
//  Created by Karolis Stasaitis on 22/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
    
    func removeSubviews() {
        arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
}
