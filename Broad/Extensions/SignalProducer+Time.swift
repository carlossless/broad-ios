//
//  SignalProducer+Time.swift
//  Broad
//
//  Created by Karolis Stasaitis on 02.06.20.
//  Copyright © 2020 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

extension SignalProducer where Value == Date, Error == Never {
    public static func acceleratedTimer(interval: DispatchTimeInterval, multiplier: Double, on scheduler: ReactiveSwift.DateScheduler) -> ReactiveSwift.SignalProducer<Value, Error> {
        var offset: Double = 0
        return self.timer(interval: interval, on: scheduler)
            .map { date in
                offset += TimeInterval(dispatchTimeInterval: interval)! * multiplier
                return date.addingTimeInterval(offset)
            }
    }

    public static func developmentTimer(interval: DispatchTimeInterval, on scheduler: ReactiveSwift.DateScheduler) -> ReactiveSwift.SignalProducer<Value, Error> {
        #if DEBUG
        return self.acceleratedTimer(interval: interval, multiplier: 60 * 5, on: scheduler) // time flies when you're having fun
        #else
        return self.timer(interval: interval, on: scheduler)
        #endif
    }
}
