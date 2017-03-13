//
//  ModelBased.swift
//  lrt
//
//  Created by Karolis Stasaitis on 07/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

protocol ConcreteModelBased {
    
    associatedtype ViewModelType
    
//    var viewModel: ViewModelType! { get set }
    func configure(for model: ViewModelType)
    
}

extension ConcreteModelBased {
    
    func configureAny(for model: ViewModel) {
        configure(for: model as! ViewModelType)
    }
    
}

protocol AnyModelBased {
    
    func configureAny(for model: ViewModel)
    
}

protocol ModelBased: ConcreteModelBased, AnyModelBased {
    
}
