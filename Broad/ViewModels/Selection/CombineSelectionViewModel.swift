//
//  CombineSelectionViewModel.swift
//  Broad
//
//  Created by Karolis Stasaitis on 02.02.21.
//  Copyright © 2021 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift

class CombineSelectionViewModel: ObservableObject {
    @Published var stations: [StationTableCellModel] = []
    
    static let ids = [
        "Lituanica": "WORLD"
    ]
    
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
    
    let apiClient: LRTStreamAPIClient
    let navigator: Navigator
    let thumbnailManager: ThumbnailManager
    
    var updateStations: Action<(), StreamDataResponse, APIError>!
    var openAboutScreen: Action<(), (), Never>!
    
    init (apiClient: LRTStreamAPIClient = LRTStreamAPIClient(), navigator: Navigator = Navigator.shared, thumbnailManager: ThumbnailManager = ThumbnailManager()) {
        self.apiClient = apiClient
        self.navigator = navigator
        self.thumbnailManager = thumbnailManager
        
        updateStations = Action<(), StreamDataResponse, APIError> { [unowned self] _ in
            return self.apiClient.stations()
        }
        
        openAboutScreen = Action<(), (), Never> { [unowned self] _ in
            self.navigator.push(model: AboutViewModel(), animated: true)
            return SignalProducer.init(value: ())
        }
        
        updateStations.values
            .map(self.buildViewModels)
            .observe(on: UIScheduler())
            .observeResult { result in
                self.stations = try! result.get()
                print("asddasd \(result)")
            }
        
        updateStations.apply()
            .observe(on: UIScheduler())
            .startWithCompleted {
            }
            
    }
    
    func buildViewModels(stations: StreamDataResponse) -> [StationTableCellModel] {
        return Array(stations.data
            .map { (station: $0, id: SelectionViewModel.ids[$0.value.name] ?? $0.value.name) }
            .filter { SelectionViewModel.order.firstIndex(of: $0.station.key) != nil })
            .sorted { st1, st2 in
                return SelectionViewModel.order.firstIndex(of: st1.id) ?? -1 < SelectionViewModel.order.firstIndex(of: st2.id) ?? -1
            }
            .map { apiStation in
                return StationTableCellModel(
                    id: apiStation.id,
                    name: SelectionViewModel.names[apiStation.id] ?? apiStation.station.value.name,
                    title: apiStation.station.value.title,
                    playlistUrl: apiStation.station.value.content,
                    thumbnailManager: self.thumbnailManager
                )
            }
    }
}
