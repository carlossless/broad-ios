//
//  StationTableCellModel.swift
//  lrt
//
//  Created by Karolis Stasaitis on 30/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

struct StationTableCellModel : ViewModel {
    
    let name: String
    let title: String?
    let playlistUrl: URL
    
    let thumbnailManager: ThumbnailManager
    
}

extension StationTableCellModel {
    
    init(name: String, title: String, playlistUrl: URL, thumbnailManager: ThumbnailManager) {
        self.name = name
        self.title = title
        self.playlistUrl = playlistUrl
        self.thumbnailManager = thumbnailManager
    }
    
    var thumbnailImage: SignalProducer<UIImage?, NoError> {
        return thumbnailManager.getThumbnailUpdateStream(for: self.name, playlistUrl: playlistUrl, size: CGSize(width: 0, height: 70))
    }
    
}
