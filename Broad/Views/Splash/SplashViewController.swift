//
//  SplashViewController.swift
//  Broad
//
//  Created by Karolis Stasaitis on 30/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift

class SplashViewController : ViewController<SplashView>, ModelBased {
    
    var viewModel: SplashViewModel!
    
    func configure(for model: SplashViewModel) {
        self.viewModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlledView.titleLabel.text = viewModel.randomLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controlledView.startAnimating()
        
        viewModel.load()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
