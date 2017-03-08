//
//  MainCell.swift
//  lrt
//
//  Created by Karolis Stasaitis on 08/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit

class MainCell : UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
