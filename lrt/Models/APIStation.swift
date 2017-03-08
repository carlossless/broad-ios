//
//  APIStation.swift
//  Conference
//
//  Created by Karolis Stasaitis on 06/08/15.
//  Copyright (c) 2015 Adroiti. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct APIStationResponse {
    let data: [String: APIStation]
}

struct APIStation {
    let name: String
    let title: String?
    let content: URL
    let enable: Bool
}

extension APIStationResponse: Decodable {
    static func decode(_ j: JSON) -> Decoded<APIStationResponse> {
        return curry(APIStationResponse.init)
            <^> (j <| ["response", "data"] >>- { [String: APIStation].decode($0) })
    }
}

extension APIStation: Decodable {
    static func decode(_ j: JSON) -> Decoded<APIStation> {
        return curry(APIStation.init)
            <^> j <| "name"
            <*> j <|? "title"
            <*> j <| "content"
            <*> j <| "enable"
    }
}

extension URL: Decodable {
    public static func decode(_ json: JSON) -> Decoded<URL> {
        switch json {
        case .string(let urlString):
            return URL(string: urlString).map(pure) ?? .typeMismatch(expected: "URL", actual: json)
        default: return .typeMismatch(expected: "URL", actual: json)
        }
    }
}
