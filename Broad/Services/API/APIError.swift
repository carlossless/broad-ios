//
//  APIError.swift
//  Broad
//
//  Created by Karolis Stasaitis on 10/9/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

enum APIError : Error {
    
    case generic(String)
    case httpFailed(Error)
    case jsonParsingFailed(Error)
    case httpStatusFailed(String)
    
}
