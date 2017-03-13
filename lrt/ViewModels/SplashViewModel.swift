//
//  SplashViewModel.swift
//  lrt
//
//  Created by Karolis Stasaitis on 31/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class SplashViewModel : ViewModel {
    
    static let loadingNames = [
        "Baking Beans...",
        "Praying...",
        "Paying Back Investors...",
        "Recombining DNA..."
    ]
    
    func randomLabel() -> String {
        return SplashViewModel.loadingNames.random()
    }
    
    func load() {
        let vm = MainViewModel()
        vm.updateStations
            .apply()
            .observe(on: UIScheduler())
            .startWithCompleted {
                Navigator.shared.replaceRoot(model: vm, animated: true, options: [.transitionCrossDissolve])
            }
    }
    
}
