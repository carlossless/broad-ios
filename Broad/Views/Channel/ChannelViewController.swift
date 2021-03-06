//
//  ChannelViewController.swift
//  Broad
//
//  Created by Karolis Stasaitis on 22/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import AVKit
import AVFoundation

class ChannelViewController : ViewController<ChannelView>, ModelBased, AVPlayerViewControllerDelegate {
    
    static let imageSize: CGSize = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 120, height: 80)
        } else {
            return CGSize(width: 60, height: 40)
        }
    }()
    
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
        addChild(videoController)
        controlledView.setVideoView(view: videoController.view)
        
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        controlledView.loadingIndicator.reactive.isAnimating <~ updateShows.isExecuting
        controlledView.timeLabel.reactive.text <~ viewModel.showName.map { $0 != nil ? R.string.localization.channel_viewNow() : nil }
        controlledView.nameLabel.reactive.text <~ viewModel.showName
        controlledView.reactive.descriptionText <~ viewModel.showDescription
        controlledView.comingUpLabel.reactive.isHidden <~ viewModel.showComingUpLabel.negate()
        controlledView.allShowsButton.reactive.isHidden <~ viewModel.showAllShowsButton.negate()
        
        controlledView.allShowsButton.reactive.pressed = CocoaAction(viewModel.showAllShows, { _ in () })
        
        viewModel.upcomingShows
            .producer
            .observe(on: UIScheduler())
            .startWithValues { [weak self] shows in
                self?.controlledView.showsStackView.removeSubviews()
                shows.forEach { model in
                    let showView = ChannelShowView()
                    showView.configure(for: model)
                    self?.controlledView.showsStackView.addArrangedSubview(showView)
                }
            }
        
        videoController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isMovingToParent {
            updateShows.execute(())
        }
        
        videoController.player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // this is to avoid pausing when the player moves into fullscreen mode
        if isMovingFromParent || navigationController?.viewControllers.last != self {
            videoController.player?.pause()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
