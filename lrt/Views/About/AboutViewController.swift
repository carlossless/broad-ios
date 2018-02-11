//
//  AboutViewController.swift
//  lrt
//
//  Created by Karolis Stasaitis on 28/9/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveCocoa

class AboutViewController : ViewController<AboutView>, ModelBased {
    
    var viewModel: AboutViewModel!
    
    func configure(for model: AboutViewModel) {
        self.viewModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        controlledView.logoButton.reactive.pressed = CocoaAction(viewModel.openLogoLink)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
