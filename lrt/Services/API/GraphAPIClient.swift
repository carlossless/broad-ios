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
    
    private let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    init (baseUrl: URL = URL(string: "https://lrt.carlossless.io")!, httpClient: HTTPClient = HTTPClient()) {
        apiBaseUrl = baseUrl
        client = httpClient
    }
    
    func latest() -> SignalProducer<GraphChannelResponse, APIError> {
        let genericQuery: String = """
        {
          channels(date: "\(dateFormatter.string(from: Date()))") {
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
    
}
