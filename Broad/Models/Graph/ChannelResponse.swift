//
//  ChannelResponse.swift
//  Broad
//
//  Created by Karolis Stasaitis on 19/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import Runes
import Curry
import Argo

struct GraphResponseWrapper<T>: Codable where T: Codable {
    
    let data: T
    
}

struct GraphChannelResponse: Codable {
    
    let channels: [GraphChannel]
    
}

struct GraphChannel: Codable {
    
    let name: String
    let shows: [GraphShow]
    
}

struct GraphShow: Codable {

    let name: String
    let description: String?
    let thumbnailUrl: URL?
    let linkUrl: URL?
    let archiveUrl: URL?
    
    let startsAt: Date
    let endsAt: Date
    
}

extension GraphShow: Equatable {
    public static func == (lhs: GraphShow, rhs: GraphShow) -> Bool {
        return lhs.name == rhs.name && lhs.startsAt == rhs.startsAt && lhs.endsAt == rhs.endsAt
    }
}
