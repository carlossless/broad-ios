//
//  APIManager.swift
//  lrt
//
//  Created by Karolis Stasaitis on 10/08/15.
//  Copyright (c) 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import Argo
import Result

class HTTPClient {
    
    init () { }
    
    // MARK: - Private Interface
    
    private func createDefaultRequest(url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> Result<Data, APIError> {
        if let response = response as? HTTPURLResponse {
            if 200..<400 ~= response.statusCode {
                return Result(value: data)
            } else {
                return Result(error: APIError.httpStatusFailed("Returned response code: \(response.statusCode)"))
            }
        } else {
            return Result(error: APIError.httpStatusFailed("No Response"))
        }
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> SignalProducer<Data, APIError> {
        return SignalProducer(result: self.handleResponse(data: data, response: response))
    }
    
    private func deserialise<T : Argo.Decodable>(data: Data) -> Result<T, APIError> where T == T.DecodedType {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            let result: Argo.Decoded<T> = decode(json)
            switch result {
            case .success(let value):
                return Result(value: value)
            case .failure(let error):
                return Result(error: APIError.jsonDecodingFailed(error))
            }
        } catch let error as NSError {
            return Result(error: APIError.jsonParsingFailed(error))
        }
    }
    
    private func deserialise<T : Argo.Decodable>(data: Data) -> SignalProducer<T, APIError> where T == T.DecodedType {
        return SignalProducer(result: deserialise(data: data))
    }
    
    private func httpUrlRequest(request: URLRequest) -> SignalProducer<(Data, URLResponse), APIError> {
        #if DEBUG
            var date: NSDate! = nil
            let reqName = "\(request.httpMethod!) \(request.url!)"
            let barier = (0..<reqName.characters.count + 26).map { _ in "=" }.joined(separator: "")
            print("======= HTTP REQ  \(reqName) =======")
            if let fields = request.allHTTPHeaderFields {
                print("HEADERS: \(fields)")
            }
            if let body = request.httpBody {
                print("DATA: \(String(data: body, encoding: String.Encoding.utf8) ?? "lenght \(body.count))")")
            }
            print(barier)
            return URLSession.shared.reactive.data(with: request)
                .on(
                    started: {
                        date = NSDate()
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
    
    public func retrieveAndParseData<T : Argo.Decodable>(url: URL) -> SignalProducer<T, APIError> where T == T.DecodedType {
        let request = self.createDefaultRequest(url: url)
        return httpUrlRequest(request: request)
            .flatMap(.concat, self.handleResponse)
            .flatMap(.concat, self.deserialise)
            .on(failed: { e in
                print("Error: \(e)\nUrl: \(url)\nHeaders: \(String(describing: request.allHTTPHeaderFields))")
            })
    }
    
}
