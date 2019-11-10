//
//  StationTableCellModel.swift
//  Broad
//
//  Created by Karolis Stasaitis on 30/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift

struct StationTableCellModel : ViewModel {
    
    let id: String
    let name: String
    let title: String?
    let playlistUrl: URL
    
    let thumbnailManager: ThumbnailManager
    
}

extension StationTableCellModel {
    
    init(id: String, name: String, title: String, playlistUrl: URL, thumbnailManager: ThumbnailManager) {
        self.id = id
        self.name = name
        self.title = title
        self.playlistUrl = playlistUrl
        self.thumbnailManager = thumbnailManager
    }
    
    var thumbnailImage: SignalProducer<UIImage?, Never> {
        return thumbnailManager.getThumbnailUpdateStream(for: self.name, playlistUrl: playlistUrl, size: CGSize(width: 0, height: 70))
    }
    
}
