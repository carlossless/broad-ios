//
//  ChannelShowViewModel.swift
//  lrt
//
//  Created by Karolis Stasaitis on 30/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

class ChannelShowViewModel : ViewModel {

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    let name: String
    let time: String
    let description: String?
    let thumbnailUrl: URL?
    
    init(name: String, time: String, description: String?, thumbnailUrl: URL?) {
        self.name = name
        self.time = time
        self.description = description
        self.thumbnailUrl = thumbnailUrl
    }
    
    convenience init(show: GraphShow) {
        self.init(
            name: show.name,
            time: ChannelShowViewModel.formatter.string(from: show.startsAt),
            description: show.description,
            thumbnailUrl: show.thumbnailUrl
        )
    }
    
}
