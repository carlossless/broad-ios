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
import Result
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
    
    let apiClient: APIClient
    let navigator: Navigator
    let thumbnailManager: ThumbnailManager
    
    let stations = MutableProperty<[StationTableCellModel]>([])
    var updateStations: Action<(), StreamDataResponse, APIError>!
    var openAboutScreen: Action<(), (), NoError>!
    
    init (apiClient: APIClient = APIClient(), navigator: Navigator = Navigator.shared, thumbnailManager: ThumbnailManager = ThumbnailManager()) {
        self.apiClient = apiClient
        self.navigator = navigator
        self.thumbnailManager = thumbnailManager
        
        updateStations = Action<(), StreamDataResponse, APIError> { [unowned self] _ in
            return self.apiClient.stations()
        }
        
        openAboutScreen = Action<(), (), NoError> { [unowned self] _ in
            self.navigator.push(model: AboutViewModel(), animated: true)
            return SignalProducer.init(value: ())
        }
        
        stations <~ updateStations.values
            .map(self.buildViewModels)
            .observe(on: UIScheduler())
    }
    
    func select(index: Int) {
        let model = stations.value[index]
        Navigator.shared.present(model: PlayerViewModel(playlistURL: model.playlistUrl), animated: true)
    }
    
    func buildViewModels(stations: StreamDataResponse) -> [StationTableCellModel] {
        return Array(stations.data
            .filter { MainViewModel.order.index(of: $0.key) != nil })
            .sorted { st1, st2 in
                return MainViewModel.order.index(of: st1.key) ?? -1 < MainViewModel.order.index(of: st2.key) ?? -1
            }
            .map { apiStation in
                return StationTableCellModel(
                    id: apiStation.value.name,
                    name: MainViewModel.names[apiStation.value.name] ?? apiStation.value.name,
                    title: apiStation.value.title,
                    playlistUrl: apiStation.value.content,
                    thumbnailManager: self.thumbnailManager
                )
            }
    }
    
}
