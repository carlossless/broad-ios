//
//  MainViewModel.swift
//  lrt
//
//  Created by Karolis Stasaitis on 07/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class MainViewModel {
    
    let stations = MutableProperty<[APIStation]>([])
    
    let updateStations = Action<(), [APIStation], NSError>({_ in
        return APIManager.sharedInstance.stations()
            .map { r in
                return Array(r.0.data.values).sorted(by: { $0.name > $1.name })
            }
    })
    
    init () {
        stations <~ updateStations.values
    }
    
}
