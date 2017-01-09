//
//  MoyaHelper.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 1/25/16.
//  Copyright © 2016 Jera. All rights reserved.
//

import Moya
import RxSwift
import Moya_ObjectMapper

/**
 Treats the error returned from Moya and returns the correct NSError
 
 - parameter errorType: The error returned from Moya
 
 - returns: NSError corresponding to the the Moya Error.
 */
public func translateMoyaError(errorType: Swift.Error) -> NSError {
    if let moyaError = errorType as? Moya.Error {
        switch moyaError {
        case .underlying(let error):
            return error as NSError
        default:
            return moyaError as NSError
        }
    } else {
        return errorType as NSError
    }
}

public extension ObservableType where E == Moya.Response {
    public func ignoreResponse() -> Observable<Void> {
        return map({ (_) -> Void in })
    }
}
