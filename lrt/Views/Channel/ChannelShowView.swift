//
//  ChannelShowView.swift
//  lrt
//
//  Created by Karolis Stasaitis on 25/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class ChannelShowView : UIView, ModelBased {
    
    private var observer: NSKeyValueObservation!
    
    var thumbnailView: UIImageView!
    var timeLabel: UILabel!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    
    func configure(for model: ChannelShowViewModel) {
        nameLabel.text = model.name
        timeLabel.text = model.time
        descriptionLabel.text = model.description
        thumbnailView.reactive.imageUrl(size: ChannelViewController.imageSize) <~ SignalProducer(value: model.thumbnailUrl)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor(hex: 0x373D55)
        
        let titleStack = UIStackView()
        titleStack.distribution = .fill
        titleStack.alignment = .top
        titleStack.spacing = 10
        
        let horizontalStack = UIStackView()
        horizontalStack.distribution = .fillProportionally
        horizontalStack.alignment = .top
        horizontalStack.spacing = 10
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        
        thumbnailView = UIImageView()
        thumbnailView.setContentHuggingPriority(.required, for: .horizontal)
        thumbnailView.setContentHuggingPriority(.init(0), for: .vertical)
        thumbnailView.setContentCompressionResistancePriority(.required, for: .horizontal)
        thumbnailView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.numberOfLines = 0
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0
        
        titleStack.addArrangedSubviews(
            nameLabel,
            timeLabel
        )
        
        verticalStack.addArrangedSubviews(
            titleStack,
            descriptionLabel
        )
        
        horizontalStack.addArrangedSubviews(
            thumbnailView,
            verticalStack
        )
        
        addSubviews(
            horizontalStack
        )
        
        horizontalStack.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(12)
        }
        
        observer = thumbnailView.observe(\.image, options: NSKeyValueObservingOptions.new) { view, change in
            if change.newValue != nil {
                horizontalStack.insertArrangedSubview(view, at: 0)
            } else {
                horizontalStack.removeArrangedSubview(view)
            }
        }
    }
    
}
