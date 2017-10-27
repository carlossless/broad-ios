//
//  UIImage+Reactive.swift
//  lrt
//
//  Created by Karolis Stasaitis on 22/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import Kingfisher

// Make this whole thing actually reactive

extension Reactive where Base: UIImageView {
    public var imageUrl: BindingTarget<URL?> {
        return makeBindingTarget { Reactive.loadImage(view: $0, url: $1) }
    }
    
    func imageUrl(size: CGSize) -> BindingTarget<URL?> {
        return makeBindingTarget { Reactive.loadImage(view: $0, url: $1, size: size) }
    }
    
    static func loadImage(view: UIImageView, url: URL?, size: CGSize? = nil) {
        let scale = UIScreen.main.scale
        var options = [KingfisherOptionsInfoItem.scaleFactor(scale)]
        if let size = size {
            options.append(
                KingfisherOptionsInfoItem.processor(
                    ResizingImageProcessor(
                        referenceSize: size,
                        mode: ContentMode.aspectFill
                    )
                )
            )
        }
        view.kf.setImage(
            with: url,
            placeholder: nil,
            options: options,
            progressBlock: nil,
            completionHandler: nil
        )
    }
}
