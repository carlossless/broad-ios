//
//  Date+Decodable.swift
//  Broad
//
//  Created by Karolis Stasaitis on 21/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import Argo

extension Date: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<Date> {
        switch json {
        case .string(let timestamp):
            if let miliSeconds = Double(timestamp) {
                return pure(Date(timeIntervalSince1970: miliSeconds / 1000))
            } else {
                return .typeMismatch(expected: "Date", actual: json)
            }
        default: return .typeMismatch(expected: "Date", actual: json)
        }
    }
}
