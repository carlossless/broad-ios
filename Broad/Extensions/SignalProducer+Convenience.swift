//
//  SignalProducer+Convenience.swift
//  Broad
//
//  Created by Karolis Stasaitis on 3/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift

extension SignalProducer {
    func optionalizeErrors() -> SignalProducer<Value?, Never> {
        return self
            .map { Optional($0) }
            .flatMapError { _ in SignalProducer<Value?, Never>.init(value: nil) }
    }
}
