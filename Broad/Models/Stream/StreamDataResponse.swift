//
//  APIStation.swift
//  Broad
//
//  Created by Karolis Stasaitis on 06/08/15.
//  Copyright (c) 2015 delanoir. All rights reserved.
//

import Foundation
import Curry

struct StreamData: Codable {
    let response: StreamDataResponse
}

struct StreamDataResponse: Codable {
    let data: [String: StreamInfo]
}

struct StreamInfo: Codable {
    let name: String
    let title: String?
    let content: URL
    let enable: Bool
}
