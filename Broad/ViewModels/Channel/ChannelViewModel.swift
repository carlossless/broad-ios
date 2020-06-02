//
//  ChannelViewModel.swift
//  Broad
//
//  Created by Karolis Stasaitis on 22/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import Curry

class ChannelViewModel: ViewModel {
    
    let apiClient: GraphAPIClient
    let navigator: Navigator
    
    let channelName: String
    let playlistUrl: URL
    let showName = MutableProperty<String?>(nil)
    let showDescription = MutableProperty<String?>(nil)
    let showThumbnailUrl = MutableProperty<URL?>(nil)
    let showComingUpLabel = MutableProperty<Bool>(false)
    let showAllShowsButton = MutableProperty<Bool>(false)
    let upcomingShows = MutableProperty<[ChannelShowViewModel]>([])
    
    var showAllShows: Action<(), (), Never>!
    var updateShows: Action<(), GraphChannelResponse, APIError>!
    
    init (channelId: String, channelName: String, playlistUrl: URL, apiClient: GraphAPIClient = GraphAPIClient(), navigator: Navigator = Navigator.shared) {
        self.apiClient = apiClient
        self.navigator = navigator
        
        self.channelName = channelName
        self.playlistUrl = playlistUrl
        
        updateShows = Action<(), GraphChannelResponse, APIError> { [unowned self] _ in
            return self.apiClient.latest()
        }
        
        let allShows = updateShows.values
        
        SignalProducer.developmentTimer(interval: DispatchTimeInterval.seconds(1), on: QueueScheduler.main)
            .prefix(value: Date())
            .combineLatest(with: allShows)
            .map { date, response in curry(ChannelViewModel.selectLatestShows)(channelId)(10)(date)(response) }
            .skipRepeats { zip($0, $1).first { $0 != $1 } == nil }
            .startWithSignal { [unowned self] showChanges, _ in
                let models = showChanges
                    .map(ChannelViewModel.buildShowViewModels)
                    .observe(on: UIScheduler())
                
                self.upcomingShows <~ models
                    .map { shows in Array(shows.dropFirst()) }
                
                let currentShow = models
                    .map { shows in shows.first }
                
                let upcomingShowsExist = upcomingShows.map { $0.count > 0 }
                
                self.showName <~ currentShow.map { $0?.name ?? "¯\\_(ツ)_/¯" }
                self.showDescription <~ currentShow.map { $0?.description }
                self.showThumbnailUrl <~ currentShow.map { $0?.thumbnailUrl }
                self.showComingUpLabel <~ upcomingShowsExist
                self.showAllShowsButton <~ upcomingShowsExist
            }
        
        showAllShows = Action(enabledIf: self.showAllShowsButton) {
            return SignalProducer {
                return Navigator.shared.push(model: ProgrammeViewModel(channelId: channelId), animated: true)
            }
        }
    }
    
    static func selectLatestShows(_ channelId: String, _ showCount: Int, now: Date, response: GraphChannelResponse) -> [GraphShow] {
        guard let channel = response.channels.first(where: { $0.name == channelId })
            else { return [] }
        
        return Array(channel.shows.filter { show in
            return show.startsAt..<show.endsAt ~= now || show.startsAt >= now
        }.prefix(showCount))
    }
    
    static func buildShowViewModels(show: [GraphShow]) -> [ChannelShowViewModel] {
        return show.map(ChannelShowViewModel.init)
    }
    
}
