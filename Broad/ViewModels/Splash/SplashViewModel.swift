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
        "Baking beans...",
        "Praying...",
        "Paying back investors...",
        "Recombining DNA...",
        "Coliding particles...",
        "Constructing additional pylons...",
        "Arguing on the internet..."
    ]
    
    func randomLabel() -> String {
        return SplashViewModel.loadingNames.random()
    }
    
    func load() {
        let vm = SelectionViewModel()
        vm.updateStations
            .apply()
            .observe(on: UIScheduler())
            .startWithCompleted {
                Navigator.shared.replaceRoot(model: vm, animated: true, options: [.transitionCrossDissolve])
            }
    }
    
}
