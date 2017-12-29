//
//  PlayerViewController.swift
//  lrt
//
//  Created by Karolis Stasaitis on 27/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController, ModelBased {
    
    func configure(for model: PlayerViewModel) {
        self.player = AVPlayer(url: model.playlistURL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.player?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == contentOverlayView?.bounds {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.player?.pause()
        
        super.viewDidDisappear(animated)
    }
    
}
