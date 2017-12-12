//
//  APIClient.swift
//  lrt
//
//  Created by Karolis Stasaitis on 18/10/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift

struct GraphQLRequest : Encodable {
    
    let query: String?
    let operationName: String?
    let variables: String?
    
    init (query: String) {
        self.query = query
        self.operationName = nil
        self.variables = nil
    }

}

class GraphAPIClient {
    
    private let apiBaseUrl: URL
    private let client: HTTPClient
    
    //TODO: Remove this duplication
    private let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        return formatter
    }()
    
    init(baseUrl: URL = URL(string: "https://lrt.carlossless.io")!, httpClient: HTTPClient = HTTPClient()) {
        apiBaseUrl = baseUrl
        client = httpClient
    }
    
    func programme(fromDate: Date, toDate: Date) -> SignalProducer<GraphChannelResponse, APIError> {
        let genericQuery: String = """
        {
          channels(from: "\(dateFormatter.string(from: fromDate))", to: "\(dateFormatter.string(from: toDate))") {
            name
            shows {
              name
              description
              thumbnailUrl
              linkUrl
              archiveUrl
              startsAt
              endsAt
            }
          }
        }
        """
        let object = GraphQLRequest(query: genericQuery)
        return (client.post(url: apiBaseUrl, object: object) as SignalProducer<GraphResponseWrapper<GraphChannelResponse>, APIError>)
            .map { wrapper in
                return wrapper.data
            }
    }
    
    func latest() -> SignalProducer<GraphChannelResponse, APIError> {
        let fromDate = Date()
        let toDate = Date(timeInterval: 24 * 60 * 60, since: fromDate) // 24 Hours
        return programme(fromDate: fromDate, toDate: toDate)
    }
    
}
