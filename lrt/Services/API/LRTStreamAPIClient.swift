//
//  LRTStreamAPIClient.swift
//  lrt
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
        return client.get(url: url)
    }
    
}
