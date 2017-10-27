//
//  ChannelViewController.swift
//  lrt
//
//  Created by Karolis Stasaitis on 22/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import AVKit
import AVFoundation

class ChannelViewController : ViewController<ChannelView>, ModelBased {
    
    var viewModel: ChannelViewModel!
    
    var updateShows: CocoaAction<Void>!
    
    var videoController = AVPlayerViewController()
    
    func configure(for model: ChannelViewModel) {
        self.viewModel = model
        
        navigationItem.title = viewModel.channelName
        updateShows = CocoaAction(viewModel.updateShows)
    }
    
    override func viewDidLoad() {
        videoController = AVPlayerViewController()
        videoController.player = AVPlayer(url: viewModel.playlistUrl)
        addChildViewController(videoController)
        controlledView.setVideoView(view: videoController.view)
        
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        controlledView.loadingIndicator.reactive.isAnimating <~ updateShows.isExecuting
        controlledView.timeLabel.reactive.text <~ viewModel.showName.map { $0 != nil ? "NOW" : nil }
        controlledView.nameLabel.reactive.text <~ viewModel.showName
        controlledView.descriptionLabel.reactive.text <~ viewModel.showDescription
        controlledView.comingUpLabel.reactive.isHidden <~ updateShows.isExecuting
        controlledView.allShowsButton.reactive.isHidden <~ updateShows.isExecuting
        
        viewModel.upcomingShows.producer.observe(on: UIScheduler()).startWithValues { [unowned self] shows in
            self.controlledView.showsStackView.removeAllArrangedSubviews()
            shows.forEach { show in
                let showView = ChannelShowView()
                showView.nameLabel.text = show.name
                showView.descriptionLabel.text = show.description
                showView.thumbnailView.reactive.imageUrl(size: CGSize(width: 60, height: 40)) <~ SignalProducer(value: show.thumbnailUrl)
                self.controlledView.showsStackView.addArrangedSubview(showView)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateShows.execute(())
        videoController.player?.play()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}