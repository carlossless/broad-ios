//
//  URL+Decodable.swift
//  lrt
//
//  Created by Karolis Stasaitis on 14/06/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import Argo

extension URL: Decodable {
    public static func decode(_ json: JSON) -> Decoded<URL> {
        switch json {
        case .string(let urlString):
            return URL(string: urlString).map(pure) ?? .typeMismatch(expected: "URL", actual: json)
        default: return .typeMismatch(expected: "URL", actual: json)
        }
    }
}
