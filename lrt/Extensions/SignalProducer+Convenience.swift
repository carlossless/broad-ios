//
//  SignalProducer+Convenience.swift
//  lrt
//
//  Created by Karolis Stasaitis on 3/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProducer {
    func optionalizeErrors() -> SignalProducer<Value?, NoError> {
        return self
            .map { Optional($0) }
            .flatMapError { _ in SignalProducer<Value?, NoError>.init(value: nil) }
    }
}
