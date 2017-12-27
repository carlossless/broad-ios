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
import Curry

class ProgrammeViewModel: ViewModel {
    
    let apiClient: GraphAPIClient

    let shows = MutableProperty<[ProgrammeShowCellModel]>([])
    var updateProgramme: Action<(), GraphChannelResponse, APIError>!

    init (channelId: String, apiClient: GraphAPIClient = GraphAPIClient()) {
        self.apiClient = apiClient

        updateProgramme = Action<(), GraphChannelResponse, APIError> { [unowned self] _ in
            let start = Date().dateFor(.startOfWeek)
            let end = start.adjust(.week, offset: 1).dateFor(.endOfWeek)
            return self.apiClient.programme(fromDate: start, toDate: end)
        }

        shows <~ updateProgramme.values
            .map(curry(ProgrammeViewModel.buildViewModels)(channelId))
            .observe(on: UIScheduler())
    }

    func select(index: Int) {
//        let model = shows.value[index]
//        Navigator.shared.push(model: ChannelViewModel(channelId: model.id, channelName: model.name, playlistUrl: model.playlistUrl), animated: true)
    }

    static func buildViewModels(channelId: String, stations: GraphChannelResponse) -> [ProgrammeShowCellModel] {
        return stations.channels
            .filter { $0.name == channelId }
            .flatMap { $0.shows }
            .map { show in
                return ProgrammeShowCellModel(
                    id: String(show.startsAt.timeIntervalSince1970),
                    name: show.name,
                    description: show.description,
                    startsAt: show.startsAt,
                    endsAt: show.endsAt,
                    thumbnailUrl: show.thumbnailUrl,
                    linkUrl: show.linkUrl,
                    archiveUrl: show.archiveUrl
                )
            }
    }

}
