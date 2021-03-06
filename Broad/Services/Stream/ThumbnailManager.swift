//
//  ThumbnailManager.swift
//  Broad
//
//  Created by Karolis Stasaitis on 07/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

class ThumbnailManager {
    
    let generator = ThumbnailGenerator()
    var cachedThumbnails: [String: UIImage] = [:]
    
    func getThumbnailUpdateStream(for key: String, playlistUrl: URL, size: CGSize) -> SignalProducer<UIImage?, Never> {
        return SignalProducer { obs, disp in
            if let cachedImage = self.cachedThumbnails[key] {
                obs.send(value: cachedImage)
            }
            let genSignal = self.generator.genImage(for: playlistUrl, size: size)
                .on(value: { [unowned self] image in
                    self.cachedThumbnails[key] = image
                })
                .optionalizeErrors()
                .start(obs)
            disp.observeEnded(genSignal.dispose)
        }
    }
    
}
