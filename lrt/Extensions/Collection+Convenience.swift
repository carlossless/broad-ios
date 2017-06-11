//
//  Collection+Convenience.swift
//  lrt
//
//  Created by Karolis Stasaitis on 09/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

extension Collection where Index == Int, IndexDistance == Int {
    
    func random() -> Iterator.Element {
        return self[IndexDistance(arc4random_uniform(UInt32(self.count)))]
    }
    
}
