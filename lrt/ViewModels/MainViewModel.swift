//
//  MainViewModel.swift
//  lrt
//
//  Created by Karolis Stasaitis on 07/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import AVFoundation
import CoreMedia

class MainViewModel : ViewModel {
    
    static let names = [
        "LTV1": "LRT Televizija",
        "LTV2": "LRT Kultūra",
        "WORLD": "LRT Lituanica",
        "LR": "LRT Radijas",
        "Klasika": "Klasika",
        "Opus": "Opus"
    ]
    
    static let order = [
        "LTV1",
        "LTV2",
        "WORLD",
        "LR",
        "Klasika",
        "Opus"
    ]
    
    let thumbnailManager = ThumbnailManager()
    
    let stations = MutableProperty<[StationTableCellModel]>([])
    let updateStations: Action<(), APIStationResponse, NSError>!
    
    init () {
        updateStations = Action<(), APIStationResponse, NSError> { _ in
            return APIManager.sharedInstance.stations()
        }
        
        stations <~ updateStations.values
            .map(self.buildViewModels)
            .observe(on: UIScheduler())
    }
    
    func buildViewModels(stations: APIStationResponse) -> [StationTableCellModel] {
        return Array(stations.data
            .filter { MainViewModel.order.index(of: $0.0) != nil }
            .sorted { st1, st2 in
                return MainViewModel.order.index(of: st1.0) ?? -1 < MainViewModel.order.index(of: st2.0) ?? -1
            }
            .map { apiStation in
                return StationTableCellModel(
                    name: MainViewModel.names[apiStation.value.name] ?? apiStation.value.name,
                    title: apiStation.value.title,
                    playlistUrl: apiStation.value.content,
                    thumbnailManager: self.thumbnailManager
                )
            }
        )
    }
    
}
