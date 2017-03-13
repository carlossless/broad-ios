//
//  APIManager.swift
//  Conference
//
//  Created by Karolis Stasaitis on 10/08/15.
//  Copyright (c) 2015 Adroiti. All rights reserved.
//

import Foundation
import ReactiveSwift
import Argo
import Result

struct APIManager {
    
    static let sharedInstance = APIManager()
    static private let apiBaseUrl = NSURL(string: "http://www.lrt.lt/")!
    
    // MARK: - Private Interface
    
    private func createDefaultRequest(url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    private func deserialise<T : Decodable>(data: Data) -> Result<T, NSError> where T == T.DecodedType {
        do {
            let json: Any? = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            if let j: AnyObject = json as AnyObject? {
                let result: Argo.Decoded<T> = decode(j)
                switch result {
                case .success(let value):
                    return Result(value: value)
                case .failure(let error):
                    switch error {
                    case .typeMismatch(let key):
                        return Result(error: Result<T, NSError>.error("Type mismatch error for key \(key)"))
                    case .missingKey(let key):
                        return Result(error: Result<T, NSError>.error("Missing key error for key \(key)"))
                    case .custom(let key):
                        return Result(error: Result<T, NSError>.error(key))
                    case .multiple(let errors):
                        return Result(error: Result<T, NSError>.error("Multiple errors \(errors)"))
                    }
                }
            }
        } catch let error as NSError {
            return Result<T, NSError>(error: error)
        }
        return Result<T, NSError>(error: NSError(domain: "fail", code: 1, userInfo: nil))
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> SignalProducer<Data, NSError> {
        return SignalProducer { subscriber, _ in
            if let response = response as? HTTPURLResponse {
                if 200..<400 ~= response.statusCode {
                    subscriber.send(value: data)
                    subscriber.sendCompleted()
                } else {
                    subscriber.send(error: NSError.APIError(string: "Returned response code: \(response.statusCode)"))
                }
            } else {
                subscriber.send(error: NSError.APIError(string: "No Response"))
            }
        }
    }
    
    private func deserialise<T : Decodable>(data: Data) -> SignalProducer<T, NSError> where T == T.DecodedType {
        return SignalProducer(result: deserialise(data: data))
    }
    
    private func retrieveAndParseData<T : Decodable>(url: URL) -> SignalProducer<(T, Date), NSError> where T == T.DecodedType {
        let request = self.createDefaultRequest(url: url)
        let date = Date()
        return httpUrlRequest(request: request)
            .flatMap(.concat, transform: self.handleResponse)
            .flatMap(.concat, transform: self.deserialise)
            .on(failed: { e in
                print("Error: \(e)\nUrl: \(url)\nHeaders: \(String(describing: request.allHTTPHeaderFields))")
            })
            .map { value in
                return (value, date)
            }
    }
    
    private func retrieveAndParseData<T : Decodable>(url: URL) -> SignalProducer<T, NSError> where T == T.DecodedType {
        return retrieveAndParseData(url: url)
            .map { value, _ in
                return value
            }
    }
    
    func httpUrlRequest(request: URLRequest) -> SignalProducer<(Data, URLResponse), NSError> {
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
                .mapError({error in error.error as NSError})
        #else
            return URLSession.shared.reactive.data(with: request)
                .mapError({error in error.error as NSError})
        #endif
    }
    
    // MARK: - Data Retrieval
    
    func stations() -> SignalProducer<APIStationResponse, NSError> {
        let url = APIManager.apiBaseUrl.appendingPathComponent("/data-service/module/live")!
        return retrieveAndParseData(url: url)
    }
    
}

extension NSError {
    
    static func APIError(string: String) -> NSError {
        return NSError(domain: "com.adroiti.beacon.api", code: 1, userInfo: [NSLocalizedDescriptionKey: string])
    }
    
}
