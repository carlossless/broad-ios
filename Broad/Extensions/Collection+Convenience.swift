//
//  Collection+Convenience.swift
//  Broad
//
//  Created by Karolis Stasaitis on 09/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

extension Collection where Index == Int {
    
    func random() -> Iterator.Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
    
}
