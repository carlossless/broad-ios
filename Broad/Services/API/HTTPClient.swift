//
//  APIManager.swift
//  Broad
//
//  Created by Karolis Stasaitis on 10/08/15.
//  Copyright (c) 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift

class HTTPClient {
    
    let httpHeaders: [String: String]
    
    init (headers: [String: String] = [:]) {
        self.httpHeaders = headers
    }
    
    // MARK: - Private Interface
    
    private func createDefaultRequest(url: URL, method: String = "GET", body: Data? = nil, contentType: String? = nil, cachePolicy: URLRequest.CachePolicy? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        httpHeaders.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        if let cachePolicy = cachePolicy {
            request.cachePolicy = cachePolicy
        }
        if let contentType = contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> Result<Data, APIError> {
        if let response = response as? HTTPURLResponse {
            if 200..<400 ~= response.statusCode {
                return .success(data)
            } else {
                return .failure(APIError.httpStatusFailed("Returned response code: \(response.statusCode)"))
            }
        } else {
            return .failure(APIError.httpStatusFailed("No Response"))
        }
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> SignalProducer<Data, APIError> {
        return SignalProducer(result: self.handleResponse(data: data, response: response))
    }
    
    //TODO: Remove this duplication
    private let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        return formatter
    }()
    
    private func deserialise<T : Swift.Decodable>(data: Data) -> Result<T, APIError> {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                let timestamp = try container.decode(String.self)
                guard let date = self.dateFormatter.date(from: timestamp) else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode timestamp string \(timestamp)")
                }
                return date
            })
            let result = try decoder.decode(T.self, from: data)
            return Result.success(result)
        } catch let error as NSError {
            return Result.failure(APIError.jsonParsingFailed(error))
        }
    }
    
    private func deserialise<T : Swift.Decodable>(data: Data) -> SignalProducer<T, APIError> {
        return SignalProducer(result: deserialise(data: data))
    }
    
    private func httpUrlRequest(request: URLRequest) -> SignalProducer<(Data, URLResponse), APIError> {
        #if DEBUG
            var date: Date! = nil
            let reqName = "\(request.httpMethod!) \(request.url!)"
            let barier = (0..<reqName.count + 26).map { _ in "=" }.joined(separator: "")
            return URLSession.shared.reactive.data(with: request)
                .on(
                    started: {
                        date = Date()
                        print("======= HTTP REQ \(reqName) =======")
                        if let fields = request.allHTTPHeaderFields {
                            print("HEADERS: \(fields)")
                        }
                        if let body = request.httpBody {
                            print("DATA: \(String(data: body, encoding: String.Encoding.utf8) ?? "lenght \(body.count))")")
                        }
                        print(barier)
                    },
                    completed: {
                        print("======= HTTP TIME \(reqName) =======")
                        print("URL: \(request.url!)")
                        print("TIME: \(-date.timeIntervalSinceNow)s")
                        print(barier)
                    },
                    value: { data, resp in
                        let resp = resp as! HTTPURLResponse
                        print("======= HTTP RESP \(reqName) =======")
                        print("HEADERS: \(resp.allHeaderFields)")
                        print("DATA: \(String(data: data, encoding: String.Encoding.utf8) ?? "lenght \(data.count)")")
                        print(barier)
                    }
                )
                .mapError({error in APIError.httpFailed(error)})
        #else
            return URLSession.shared.reactive.data(with: request)
                .mapError({error in APIError.httpFailed(error)})
        #endif
    }
    
    // MARK: - Public
    
    public func retrieveData(request: URLRequest) -> SignalProducer<Data, APIError> {
        return httpUrlRequest(request: request)
            .flatMap(.concat, self.handleResponse)
    }
    
    public func retrieveAndParseData<T : Swift.Decodable>(request: URLRequest) -> SignalProducer<T, APIError> {
        return retrieveData(request: request)
            .flatMap(.concat, self.deserialise)
    }
    
    // MARK: - GET
    
    public func get(url: URL, cachePolicy: URLRequest.CachePolicy? = nil) -> SignalProducer<Data, APIError> {
        let request = self.createDefaultRequest(url: url, method: "GET", cachePolicy: cachePolicy)
        return retrieveData(request: request)
    }
    
    public func get<T : Swift.Decodable>(url: URL, cachePolicy: URLRequest.CachePolicy? = nil) -> SignalProducer<T, APIError> {
        let request = self.createDefaultRequest(url: url, method: "GET", cachePolicy: cachePolicy)
        return retrieveAndParseData(request: request)
    }
    
    // MARK: - Post
    
    public func post(url: URL, data: Data? = nil, isJson: Bool = false) -> SignalProducer<Data, APIError> {
        let request = self.createDefaultRequest(url: url, method: "POST", body: data, contentType: isJson ? "application/json; charset=utf-8" : nil)
        return retrieveData(request: request)
    }
    
    public func post<T: Swift.Decodable>(url: URL, data: Data? = nil, isJson: Bool = false) -> SignalProducer<T, APIError> {
        let request = self.createDefaultRequest(url: url, method: "POST", body: data, contentType: isJson ? "application/json; charset=utf-8" : nil)
        return retrieveAndParseData(request: request)
    }
    
    public func post<T: Encodable>(url: URL, object: T? = nil) -> SignalProducer<Data, APIError> {
        return post(url: url, data: try! JSONEncoder().encode(object), isJson: true)
    }
    
    public func post<T: Swift.Decodable, U: Encodable>(url: URL, object: U? = nil) -> SignalProducer<T, APIError> {
        return post(url: url, data: try! JSONEncoder().encode(object), isJson: true)
    }
    
}
