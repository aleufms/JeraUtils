//
//  TransformTypes.swift
//  beblueapp
//
//  Created by Alessandro Nakamuta on 9/14/15.
//  Copyright (c) 2015 Ativo. All rights reserved.
//

import ObjectMapper

//For APIs that don't return an integer, instead returns an integer within a string (JSONLess API)
class IntStringTransform: TransformType {
    typealias Object = Int64
    typealias JSON = String

    func transformFromJSON(value: AnyObject?) -> Object? {
        if let string = value as? JSON {
            return Int64(string.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
        }
        return nil
    }

    func transformToJSON(value: Object?) -> JSON? {
        if let int = value {
            return "\(int)"
        }
        return nil
    }
}

class StringIntTransform: TransformType {
    typealias Object = String
    typealias JSON = Int64
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        if let int = value as? JSON {
            return "\(int)"
        }
        return nil
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        if let string = value {
            return Int64(string.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
        }
        return nil
    }
}


//API stores CPF as int. If CPF starts with zeros, API ommits it.
//Assuming that CPF always have 11 digits, if API returns CPF with less than that
//fill the string with left zeros
class CPFTransform: TransformType {
    typealias Object = String
    typealias JSON = Int64
    
    lazy var leftZerosFillerFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
//        formatter.paddingPosition = .BeforePrefix
//        formatter.paddingCharacter = "0"
        formatter.minimumIntegerDigits = 11
        
        return formatter
    }()
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        if let intValue = value as? Int {
            if let cpf = leftZerosFillerFormatter.stringFromNumber(NSNumber(integer: intValue)){
                return "\(cpf)"
            }
        }
        else if let intValue = value as? Int64 {
            if let cpf = leftZerosFillerFormatter.stringFromNumber(NSNumber(longLong: intValue)){
                return "\(cpf)"
            }
        }
        return nil
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        if let string = value {
            return Int64(string.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
        }
        return nil
    }
}

//For APIs that don't return a double, instead returns a double within a string (JSONLess API)
class DoubleStringTransform: TransformType {
    typealias Object = Double
    typealias JSON = String

    func transformFromJSON(value: AnyObject?) -> Double? {
        if let string = value as? String {
            return Double(string)
        }
        return nil
    }

    func transformToJSON(value: Double?) -> String? {
        if let double = value {
            return "\(double)"
        }
        return nil
    }
}

//For APIs that don't return nil, instead returns an empty string (JSONLess API)
class StringEmptySafeTransform: TransformType {
    typealias Object = String
    typealias JSON = String

    func transformFromJSON(value: AnyObject?) -> String? {
        if let string = value as? String where string.characters.count > 0 {
            if string == "null"{
                return nil
            }
            return string
        }
        return nil
    }

    func transformToJSON(value: String?) -> String? {
        return value
    }
}

//For APIs that don't return bool value, instead returns string "1" for true and "0" for false (JSONLess API)
class BoolTransform: TransformType {
    typealias Object = Bool
    typealias JSON = String

    func transformFromJSON(value: AnyObject?) -> Bool? {
        if let boolString = value as? String where boolString == "1"{
            return true
        }
        return false
    }

    func transformToJSON(value: Bool?) -> String? {
        if let bool = value {
            if bool {
                return "1"
            }else {
                return "0"
            }
        }
        return nil
    }
}

class URLTransform: TransformType {
    typealias Object = NSURL
    typealias JSON = String

    func transformFromJSON(value: AnyObject?) -> NSURL? {
        if let urlString = value as? String where urlString.characters.count > 0 {
            if let UTF8URLString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
                if let webSiteURL = NSURL(string: UTF8URLString) {
                    if webSiteURL.scheme.isEmpty {
                        let trimmedResourceSpecifier = webSiteURL.resourceSpecifier.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "/"))
                        if trimmedResourceSpecifier.characters.count > 0 {
                            return NSURL(string: "http://\(trimmedResourceSpecifier)") //for URLs without scheme
                        }
                    }

                    return webSiteURL
                }
            }
        }
        return nil
    }

    func transformToJSON(value: NSURL?) -> String? {
        if let url = value {
            return url.absoluteString
        }
        return nil
    }
}

class MilisecondsTimeStampTransform: TransformType {
    typealias Object = NSDate
    typealias JSON = NSTimeInterval
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        if let timeInterval = value as? JSON {
            let date = NSDate(timeIntervalSince1970: timeInterval/1000)
            
            return date
        }
        return nil
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        if let date = value {
            return date.timeIntervalSince1970
        }
        return nil
    }
}

class BaseDateTransform: TransformType {
    typealias Object = NSDate
    typealias JSON = String
    var formatString: String
    var isGMT = false

    init(formatString: String, isGMT: Bool = false) {
        self.formatString = formatString
        self.isGMT = isGMT
    }

    func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let dateString = value as? String {

            let formatter = NSDateFormatter()
            formatter.dateFormat = formatString
            if isGMT {
                formatter.timeZone = NSTimeZone(name: "GMT")
            }
            return formatter.dateFromString(dateString)
        }
        return nil
    }

    func transformToJSON(value: NSDate?) -> String? {
        if let date = value {
            let formatter = NSDateFormatter()
            formatter.dateFormat = formatString
            return formatter.stringFromDate(date)
        }
        return nil
    }
}

class ShortDateTransform: BaseDateTransform {
    init() {
        super.init(formatString: "yyyy-MM-dd")
    }
}

class GMTLongDateTransform: BaseDateTransform {
    init() {
        super.init(formatString: "yyyy-MM-dd HH:mm:ss", isGMT: true)
    }
}

class LongDateTransform: BaseDateTransform {
    init() {
        super.init(formatString: "yyyy-MM-dd HH:mm:ss zzzz")
    }
}
