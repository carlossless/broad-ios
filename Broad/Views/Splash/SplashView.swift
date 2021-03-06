//
//  SplashView.swift
//  Broad
//
//  Created by Karolis Stasaitis on 30/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import CoreGraphics

class SplashView : UIView {
    
    var logoView: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor(hex: 0x202535)
        
        logoView = UIImageView()
        logoView.contentMode = .scaleAspectFit
        logoView.image = R.image.logo()
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.alpha = 0
        
        addSubviews(
            logoView,
            titleLabel
        )
        
        logoView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
        }
    }
    
    func startAnimating() {
        UIView.animate(withDuration: 1.0) {
            self.logoView.snp.remakeConstraints { make in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self.titleLabel.snp.top).offset(-15)
                make.width.equalTo(50)
                make.height.equalTo(50)
            }
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
            self.titleLabel.alpha = 1
        }, completion: nil)
        
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double(CGFloat.pi * 2))
        rotation.beginTime = CACurrentMediaTime() + 1
        rotation.duration = 0.3
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        self.logoView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
}
