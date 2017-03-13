//
//  StationTableViewCell.swift
//  lrt
//
//  Created by Karolis Stasaitis on 26/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import SnapKit
import ReactiveSwift
import ReactiveCocoa

class StationTableViewCell : UITableViewCell, ModelBased {
    
    var viewModel: StationTableCellModel!
    
    var titleLabel: UILabel!
    var programmeLabel: UILabel!
    var thumbnailImageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor(hex: 0x202535)
        selectedBackgroundView = UIView()
        selectedBackgroundView!.backgroundColor = UIColor(hex: 0x161A2C)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        
        programmeLabel = UILabel()
        programmeLabel.font = UIFont.systemFont(ofSize: 12)
        programmeLabel.textColor = UIColor(hex: 0xB8BCC8)
        programmeLabel.numberOfLines = 0
        
        thumbnailImageView = UIImageView()
        thumbnailImageView.setContentHuggingPriority(1000, for: .horizontal)
        thumbnailImageView.setContentCompressionResistancePriority(1000, for: .horizontal)
        
        activityIndicator = UIActivityIndicatorView()
        
        addSubviews(
            titleLabel,
            programmeLabel,
            thumbnailImageView,
            activityIndicator
        )
        
        let layoutGuide = UILayoutGuide()
        self.addLayoutGuide(layoutGuide)
        
        layoutGuide.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(self).offset(10)
            make.leading.equalTo(self.snp.leadingMargin)
            make.trailing.equalTo(thumbnailImageView.snp.leading).offset(-15)
            make.bottom.lessThanOrEqualTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(layoutGuide)
            make.left.equalTo(layoutGuide)
            make.right.equalTo(layoutGuide)
        }
        
        programmeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(layoutGuide)
            make.right.equalTo(layoutGuide)
            make.bottom.equalTo(layoutGuide)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.trailing.equalTo(self.snp.trailingMargin)
            make.bottom.equalTo(self).offset(-10)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalTo(thumbnailImageView)
        }
    }
    
    func configure(for model: StationTableCellModel) {
        self.titleLabel.text = model.name
        self.programmeLabel.text = model.title ?? "¯\\_(ツ)_/¯"
        self.thumbnailImageView.reactive.image <~ model.thumbnailImage
            .on(
                started: {
                    self.activityIndicator.startAnimating()
                },
                completed: {
                    self.thumbnailImageView.alpha = 0
                    UIView.animate(withDuration: 0.4) {
                        self.thumbnailImageView.alpha = 1
                    }
                    self.activityIndicator.stopAnimating()
                },
                interrupted: {
                    self.activityIndicator.stopAnimating()
                }
            )
            .take(until: self.reactive.prepareForReuse)
    }
    
}
