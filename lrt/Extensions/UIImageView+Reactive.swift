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

extension Reactive where Base: UIImageView {
    public var imageUrl: BindingTarget<URL?> {
        return makeBindingTarget { Reactive.loadImage(view: $0, url: $1) }
    }
    
    static func loadImage(view: UIImageView, url: URL?) {
        let scale = UIScreen.main.scale
        view.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                KingfisherOptionsInfoItem.processor(
                    ResizingImageProcessor(
                        referenceSize: CGSize(width: 60, height: 40),
                        mode: ContentMode.aspectFill
                    )
                ),
                KingfisherOptionsInfoItem.scaleFactor(scale)
            ],
            progressBlock: nil,
            completionHandler: nil
        )
    }
}
