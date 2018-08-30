//
//  APIStation.swift
//  Broad
//
//  Created by Karolis Stasaitis on 06/08/15.
//  Copyright (c) 2015 delanoir. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct StreamDataResponse {
    let data: [String: StreamInfo]
}

struct StreamInfo {
    let name: String
    let title: String?
    let content: URL
    let enable: Bool
}

extension StreamDataResponse: Argo.Decodable {
    static func decode(_ j: JSON) -> Decoded<StreamDataResponse> {
        return curry(StreamDataResponse.init)
            <^> (j <| ["response", "data"] >>- { [String: StreamInfo].decode($0) })
    }
}

extension StreamInfo: Argo.Decodable {
    static func decode(_ j: JSON) -> Decoded<StreamInfo> {
        return curry(StreamInfo.init)
            <^> j <| "name"
            <*> j <|? "title"
            <*> j <| "content"
            <*> j <| "enable"
    }
}
