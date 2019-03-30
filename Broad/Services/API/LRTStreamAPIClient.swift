//
//  BroadStreamAPIClient.swift
//  Broad
//
//  Created by Karolis Stasaitis on 18/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift

class LRTStreamAPIClient {
    
    private let apiBaseUrl: URL
    private let client: HTTPClient
    
    init (baseUrl: URL = URL(string: "http://www.lrt.lt")!, httpClient: HTTPClient = HTTPClient()) {
        apiBaseUrl = baseUrl
        client = httpClient
    }
    
    public func stations() -> SignalProducer<StreamDataResponse, APIError> {
        let url = apiBaseUrl.appendingPathComponent("/data-service/module/live")
        let data: SignalProducer<StreamData, APIError> = client.get(url: url, cachePolicy: .reloadIgnoringCacheData)
        return data.map(\StreamData.response)
    }
    
}
