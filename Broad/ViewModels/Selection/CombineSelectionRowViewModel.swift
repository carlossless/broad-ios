//
//  CombineSelectionRowViewModel.swift
//  Broad
//
//  Created by Karolis Stasaitis on 02.02.21.
//  Copyright © 2021 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftUI

class CombineSelectionRowViewModel : ViewModel, Identifiable, ObservableObject {
    
    @Published var thumbnail: UIImage?
    @Published var id: String?
    @Published var name: String?
    @Published var title: String?
    @Published var playlistUrl: URL?
    
    let thumbnailManager: ThumbnailManager = ThumbnailManager()
    
    func load(model: StationTableCellModel) {
        self.id = model.id
        self.name = model.name
        self.title = model.title
        self.playlistUrl = model.playlistUrl
        
        self.thumbnailImage.startWithValues { image in
            self.thumbnail = image
        }
    }
    
//    init(id: String, name: String, title: String, playlistUrl: URL, thumbnailManager: ThumbnailManager) {
//        self.id = id
//        self.name = name
//        self.title = title
//        self.playlistUrl = playlistUrl
//        self.thumbnailManager = thumbnailManager
//
//        thumbnailImage.startWithResult({ result in
//            self.thumbnail = try! result.get()
//        })
//    }
//
    var thumbnailImage: SignalProducer<UIImage?, Never> {
        return thumbnailManager.getThumbnailUpdateStream(for: self.name!, playlistUrl: playlistUrl!, size: CGSize(width: 0, height: 70))
    }
    
}
