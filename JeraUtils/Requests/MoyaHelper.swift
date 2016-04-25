//
//  MoyaHelper.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 1/25/16.
//  Copyright © 2016 Jera. All rights reserved.
//

import Moya

func translateMoyaError(errorType: ErrorType) -> NSError{
    if let moyaError = errorType as? Moya.Error {
        switch moyaError{
        case .Underlying(let error):
            return error as NSError
        default:
            return moyaError as NSError
        }
    }else {
        return errorType as NSError
    }
}