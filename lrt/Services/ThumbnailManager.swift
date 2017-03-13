//
//  ThumbnailManager.swift
//  lrt
//
//  Created by Karolis Stasaitis on 07/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Result

class ThumbnailManager {
    
    let generator = ThumbnailGenerator()
    var cachedThumbnails: [String: UIImage] = [:]
    
    func getThumbnailUpdateStream(for key: String, playlistUrl: URL, size: CGSize) -> SignalProducer<UIImage?, NoError> {
        return SignalProducer { obs, disp in
            if let cachedImage = self.cachedThumbnails[key] {
                obs.send(value: cachedImage)
            }
            let genSignal = self.generator.genImage(for: playlistUrl, size: CGSize(width: 0, height: 80))
                .on(value: { image in self.cachedThumbnails[key] = image })
                .start(obs)
            disp.add(genSignal)
        }
    }
    
}
