//
//  ModelBased.swift
//  Broad
//
//  Created by Karolis Stasaitis on 07/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

protocol ConcreteModelBased {
    
    associatedtype ViewModelType
    
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
