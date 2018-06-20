//
//  AboutView.swift
//  lrt
//
//  Created by Karolis Stasaitis on 28/9/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit

class AboutView : UIView {
    
    var logoButton: UIButton!
    var infoLabel: UILabel!
    
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
        
        logoButton = UIButton()
        logoButton.setImage(R.image.delanoirLogo(), for: .normal)
        
        infoLabel = UILabel()
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.alpha = 0
        
        addSubviews(
            logoButton,
            infoLabel
        )
        
        logoButton.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
    
}
