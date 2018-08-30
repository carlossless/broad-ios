//
//  ThumbnailGenerator.swift
//  Broad
//
//  Created by Karolis Stasaitis on 30/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Dispatch

class ThumbnailGenerator {
    
    let grabber = LRTStreamImageGrabber()
    let queue = DispatchQueue(label: "com.delanoir.lrt.ThumbnailGenerator", qos: DispatchQoS.userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    
    func genImage(for playlistUrl: URL, size: CGSize) -> SignalProducer<UIImage, NSError> {
        return SignalProducer { obs, _ in
                self.queue.async {
                    do {
                        let image = try self.grabber.generateImage(for: playlistUrl, size: size)
                        obs.send(value: image)
                        obs.sendCompleted()
                    } catch let error as NSError {
                        obs.send(error: error)
                    }
                }
            }
            .observe(on: UIScheduler())
    }
    
}
