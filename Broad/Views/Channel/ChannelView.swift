//
//  ChannelView.swift
//  Broad
//
//  Created by Karolis Stasaitis on 22/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import SnapKit

class ChannelView : UIView {
    
    var scrollView: UIScrollView!
    var constrainedView: UIView!
    
    var backgroundView: UIView!
    var loadingIndicator: UIActivityIndicatorView!
    
    var videoView: UIView!
    var timeLabel: UILabel!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    
    var comingUpLabel: UILabel!
    var allShowsButton: UIButton!
    
    var showsStackView: UIStackView!
    
    var nameBottomContraint: Constraint!
    var descriptionBottomContraint: Constraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor(hex: 0x202535)
        
        scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
        constrainedView = UIView()
        
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hex: 0x373D55)
        
        loadingIndicator = UIActivityIndicatorView(style: .white)
        
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
        
        comingUpLabel = UILabel()
        comingUpLabel.font = UIFont.boldSystemFont(ofSize: 13)
        comingUpLabel.textColor = UIColor(hex: 0xA3A3A3)
        comingUpLabel.text = "Coming up:"
        comingUpLabel.isHidden = true
        
        allShowsButton = UIButton()
        allShowsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        allShowsButton.setTitleColor(UIColor(hex: 0x6484FF), for: .normal)
        allShowsButton.setTitle("All Shows >", for: .normal)
        allShowsButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        allShowsButton.setContentHuggingPriority(.required, for: .horizontal)
        allShowsButton.isHidden = true
        
        showsStackView = UIStackView()
        showsStackView.axis = .vertical
        showsStackView.spacing = 1
        
        backgroundView.addSubviews(
            nameLabel,
            timeLabel,
            descriptionLabel,
            loadingIndicator
        )
        
        constrainedView.addSubviews(
            backgroundView,
            comingUpLabel,
            allShowsButton,
            showsStackView
        )
        
        scrollView.addSubview(constrainedView)
        
        addSubview(scrollView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(12)
            make.left.equalTo(backgroundView).offset(12)
            make.right.equalTo(timeLabel.snp.left).offset(-10)
            self.nameBottomContraint = make.bottom.equalTo(backgroundView).offset(-12).constraint
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(12)
            make.right.equalTo(backgroundView).offset(-12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(backgroundView).offset(12)
            make.right.equalTo(backgroundView).offset(-12)
            self.descriptionBottomContraint = make.bottom.equalTo(backgroundView).offset(-12).constraint
        }
        
        self.descriptionBottomContraint.deactivate()
        
        loadingIndicator.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(backgroundView).offset(12)
            make.centerX.equalTo(backgroundView)
            make.bottom.lessThanOrEqualTo(backgroundView).offset(-12)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.left.equalTo(constrainedView)
            make.right.equalTo(constrainedView)
        }
        
        comingUpLabel.snp.makeConstraints { make in
            make.firstBaseline.equalTo(self.allShowsButton)
            make.left.equalTo(constrainedView).offset(12)
            make.right.equalTo(self.allShowsButton.snp.left)
        }
        
        allShowsButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(8)
            make.right.equalTo(constrainedView).offset(-12)
        }
        
        showsStackView.snp.makeConstraints { make in
            make.top.equalTo(allShowsButton.snp.bottom).offset(8)
            make.left.equalTo(constrainedView)
            make.right.equalTo(constrainedView)
            make.bottom.equalTo(constrainedView)
        }
        
        constrainedView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(self)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    var descriptionText: String? {
        get {
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
            if newValue != nil && newValue?.isEmpty == false {
                self.nameBottomContraint.deactivate()
                self.descriptionBottomContraint.activate()
            } else {
                self.descriptionBottomContraint.deactivate()
                self.nameBottomContraint.activate()
            }
        }
    }
    
    func setVideoView(view: UIView) {
        videoView = view
        constrainedView.addSubview(videoView)
        
        videoView.snp.makeConstraints { make in
            make.top.equalTo(constrainedView)
            make.left.equalTo(constrainedView)
            make.right.equalTo(constrainedView)
            make.height.equalTo(constrainedView.snp.width).multipliedBy(9.0/16.0)
            make.bottom.equalTo(self.backgroundView.snp.top)
        }
    }
    
}

extension Reactive where Base: ChannelView {
    var descriptionText: BindingTarget<String?> {
        return makeBindingTarget { $0.descriptionText = $1 }
    }
}
