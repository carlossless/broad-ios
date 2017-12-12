//
//  ProgrammeViewModel.swift
//  lrt
//
//  Created by Karolis Stasaitis on 8/11/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import DateHelper

class ProgrammeViewModel: ViewModel {
    
    let apiClient: GraphAPIClient

    let shows = MutableProperty<[StationTableCellModel]>([])
    var updateProgramme: Action<(), GraphChannelResponse, APIError>!

    init (channelId: String, apiClient: GraphAPIClient = GraphAPIClient()) {
        self.apiClient = apiClient

        updateProgramme = Action<(), GraphChannelResponse, APIError> { [unowned self] _ in
            let start = Date().dateFor(.startOfWeek)
            let end = start.adjust(.week, offset: 1).dateFor(.endOfWeek)
            return self.apiClient.programme(fromDate: start, toDate: end)
        }

//        shows <~ updateProgramme.values
//            .map(self.buildViewModels)
//            .observe(on: UIScheduler())
    }

    func select(index: Int) {
        let model = shows.value[index]
        Navigator.shared.push(model: ChannelViewModel(channelId: model.id, channelName: model.name, playlistUrl: model.playlistUrl), animated: true)
    }

//    func buildViewModels(stations: GraphChannelResponse) -> [StationTableCellModel] {
//        return Array(shows.data
//            .map { (station: $0, id: SelectionViewModel.ids[$0.value.name] ?? $0.value.name) }
//            .filter { SelectionViewModel.order.index(of: $0.station.key) != nil })
//            .sorted { st1, st2 in
//                return SelectionViewModel.order.index(of: st1.id) ?? -1 < SelectionViewModel.order.index(of: st2.id) ?? -1
//            }
//            .map { apiStation in
//                return StationTableCellModel(
//                    id: apiStation.id,
//                    name: SelectionViewModel.names[apiStation.id] ?? apiStation.station.value.name,
//                    title: apiStation.station.value.title,
//                    playlistUrl: apiStation.station.value.content,
//                    thumbnailManager: self.thumbnailManager
//                )
//        }
//    }

}
