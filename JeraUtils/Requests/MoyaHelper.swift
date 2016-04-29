//
//  MoyaHelper.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 1/25/16.
//  Copyright © 2016 Jera. All rights reserved.
//

import Moya

/**
 Treats the error returned from Moya and returns the correct NSError
 
 - parameter errorType: The error returned from Moya
 
 - returns: NSError corresponding to the the Moya Error.
 */
public func translateMoyaError(errorType: ErrorType) -> NSError {
    if let moyaError = errorType as? Moya.Error {
        switch moyaError {
        case .Underlying(let error):
            return error as NSError
        default:
            return moyaError as NSError
        }
    } else {
        return errorType as NSError
    }
}
