//
//  ChannelViewModel.swift
//  lrt
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
    let upcomingShows = MutableProperty<[GraphShow]>([])
    var updateShows: Action<(), GraphChannelResponse, APIError>!
    
    init (channelId: String, channelName: String, playlistUrl: URL, apiClient: GraphAPIClient = GraphAPIClient(), navigator: Navigator = Navigator.shared) {
        self.apiClient = apiClient
        self.navigator = navigator
        
        self.channelName = channelName
        self.playlistUrl = playlistUrl
        
        updateShows = Action<(), GraphChannelResponse, APIError> { [unowned self] _ in
            return self.apiClient.latest()
        }
        
        let shows = updateShows.values
            .map(curry(ChannelViewModel.selectLatestShows)(channelId)(10)).observe(on: UIScheduler())
        
        upcomingShows <~ shows
            .map { shows in Array(shows.dropFirst()) }
        
        let currentShow = shows
            .map { shows in shows.first }
        
        showName <~ currentShow.map { $0?.name }
        showDescription <~ currentShow.map { $0?.description }
        showThumbnailUrl <~ currentShow.map { $0?.thumbnailUrl }
    }
    
    static func selectLatestShows(_ channelId: String, _ showCount: Int, response: GraphChannelResponse) -> [GraphShow] {
        let now = Date()
        
        guard let channel = response.channels.first(where: { $0.name == channelId })
            else { return [] }
        
        return Array(channel.shows.filter { show in
            return show.startsAt..<show.endsAt ~= now || show.startsAt >= now
        }.prefix(showCount))
    }
    
}
