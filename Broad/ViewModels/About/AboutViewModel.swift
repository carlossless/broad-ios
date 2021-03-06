//
//  AboutViewModel.swift
//  Broad
//
//  Created by Karolis Stasaitis on 28/9/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

struct AboutViewModel : ViewModel {
    
    var openLogoLink = Action<(), (), Never> { _ in
        UIApplication.shared.open(URL(string: "https://delanoir.com")!, options: [:], completionHandler: nil)
        return SignalProducer.init(value: ())
    }
    
}
