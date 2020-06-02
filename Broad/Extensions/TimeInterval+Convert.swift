//
//  DispatchTimeInterval+Convert.swift
//  Broad
//
//  Created by Karolis Stasaitis on 02.06.20.
//  Copyright © 2020 delanoir. All rights reserved.
//

import Foundation

extension TimeInterval {
    init?(dispatchTimeInterval: DispatchTimeInterval) {
        switch dispatchTimeInterval {
        case .seconds(let value):
            self = Double(value)
        case .milliseconds(let value):
            self = Double(value) / 1_000
        case .microseconds(let value):
            self = Double(value) / 1_000_000
        case .nanoseconds(let value):
            self = Double(value) / 1_000_000_000
        case .never:
            return nil
        @unknown default:
            fatalError()
        }
    }
}
