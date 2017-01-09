//
//  TransformTypes.swift
//  beblueapp
//
//  Created by Alessandro Nakamuta on 9/14/15.
//  Copyright (c) 2015 Ativo. All rights reserved.
//

import ObjectMapper

//For APIs that don't return an integer, instead returns an integer within a string (JSONLess API)
public class IntStringTransform: TransformType {
    public typealias Object = Int64
    public typealias JSON = String
    
    public init(){ }

    /**
     Retrieves an Int that was sent as a String in a JSON.
     
     - parameter value: A JSON containing an Int as a String.
     
     - returns: Returns the retrieved Int.
     */
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let string = value as? JSON {
            return Int64(string.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))
        }
        return nil
    }

    /**
     Transform an Int value into a String to send as a JSON
     
     - parameter value: Int value
     
     - returns: String of the Int value
     */
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let int = value {
            return "\(int)"
        }
        return nil
    }
}

public class StringIntTransform: TransformType {
    public typealias Object = String
    public typealias JSON = Int64
    
    public init(){ }

    /**
     Retrieves a String that was sent as an Int in a JSON.
     
     - parameter value: A JSON containing a String as an Int.
     
     - returns: Returns the retrieved String.
     */
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let int = value as? JSON {
            return "\(int)"
        }
        return nil
    }

    /**
     Transform a String value into an Int to send as a JSON
     
     - parameter value: String value
     
     - returns: Int of the String value
     */
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let string = value {
            return Int64(string.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))
        }
        return nil
    }
}



/**
 API stores CPF as int. If CPF starts with zeros, API ommits it.
 Assuming that CPF always have 11 digits, if API returns CPF with less than that
 fill the string with left zeros
*/
public class CPFTransform: TransformType {
    public typealias Object = String
    public typealias JSON = Int64
    
    public init(){ }

    /// Formats the CPF to always have 11 characters
    public lazy var leftZerosFillerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
//        formatter.paddingPosition = .BeforePrefix
//        formatter.paddingCharacter = "0"
        formatter.minimumIntegerDigits = 11

        return formatter
    }()

    /**
     Retrieves a CPF String that was sent as an Int in a JSON.
     
     - parameter value: A JSON containing a CPF as an Int.
     
     - returns: Returns the retrieved CPF.
     */
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let intValue = value as? Int {
            if let cpf = leftZerosFillerFormatter.string(from: NSNumber(value: intValue)) {
                return "\(cpf)"
            }
        } else if let intValue = value as? Int64 {
            if let cpf = leftZerosFillerFormatter.string(from: NSNumber(value: intValue)) {
                return "\(cpf)"
            }
        }
        return nil
    }

    /**
     Transform a CPF String into an Int to send as a JSON
     
     - parameter value: CPF String
     
     - returns: Int of the CPF String
     */
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let string = value {
            
            return Int64(string.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))
        }
        return nil
    }
}

//For APIs that don't return a double, instead returns a double within a string (JSONLess API)
public class DoubleStringTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = String
    
    public init(){ }

    public func transformFromJSON(_ value: Any?) -> Double? {
        if let string = value as? String {
            return Double(string)
        }
        return nil
    }

    public func transformToJSON(_ value: Double?) -> String? {
        if let double = value {
            return "\(double)"
        }
        return nil
    }
}

//For APIs that don't return nil, instead returns an empty string (JSONLess API)
public class StringEmptySafeTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    public init(){ }

    public func transformFromJSON(_ value: Any?) -> String? {
        if let string = value as? String, string.characters.count > 0 {
            if string == "null"{
                return nil
            }
            return string
        }
        return nil
    }

    public func transformToJSON(_ value: String?) -> String? {
        return value
    }
}

//For APIs that don't return bool value, instead returns string "1" for true and "0" for false (JSONLess API)
public class BoolTransform: TransformType {
    public typealias Object = Bool
    public typealias JSON = String
    
    public init(){ }

    public func transformFromJSON(_ value: Any?) -> Bool? {
        if let boolString = value as? String, boolString == "1"{
            return true
        }
        return false
    }

    public func transformToJSON(_ value: Bool?) -> String? {
        if let bool = value {
            if bool {
                return "1"
            } else {
                return "0"
            }
        }
        return nil
    }
}

public class URLTransform: TransformType {
    public typealias Object = NSURL
    public typealias JSON = String
    
    public init(){ }

    public func transformFromJSON(_ value: Any?) -> NSURL? {
        if let urlString = value as? String, urlString.characters.count > 0 {
            
            if let UTF8URLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                if let webSiteURL = NSURL(string: UTF8URLString) {
                    if let scheme = webSiteURL.scheme, scheme.isEmpty {
                        if let resourceSpecifier = webSiteURL.resourceSpecifier{
                            let trimmedResourceSpecifier = resourceSpecifier.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                            if trimmedResourceSpecifier.characters.count > 0 {
                                return NSURL(string: "http://\(trimmedResourceSpecifier)") //for URLs without scheme
                            }
                        }
                    }

                    return webSiteURL
                }
            }
        }
        return nil
    }

    public func transformToJSON(_ value: NSURL?) -> String? {
        if let url = value {
            return url.absoluteString
        }
        return nil
    }
}

public class MilisecondsTimeStampTransform: TransformType {
    public typealias Object = NSDate
    public typealias JSON = TimeInterval
    
    public init(){
        
    }

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let timeInterval = value as? JSON {
            let date = NSDate(timeIntervalSince1970: timeInterval/1000)

            return date
        }
        return nil
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            return date.timeIntervalSince1970
        }
        return nil
    }
}

public class BaseDateTransform: TransformType {
    public typealias Object = NSDate
    public typealias JSON = String
    public var formatString: String
    public var isGMT = false

    public init(formatString: String, isGMT: Bool = false) {
        self.formatString = formatString
        self.isGMT = isGMT
    }

    public func transformFromJSON(_ value: Any?) -> NSDate? {
        if let dateString = value as? String {

            let formatter = DateFormatter()
            formatter.dateFormat = formatString
            if isGMT {
                formatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
            }
            return formatter.date(from: dateString) as NSDate?
        }
        return nil
    }

    public func transformToJSON(_ value: NSDate?) -> String? {
        if let date = value {
            let formatter = DateFormatter()
            formatter.dateFormat = formatString
            return formatter.string(from: date as Date)
        }
        return nil
    }
}

public class ShortDateTransform: BaseDateTransform {
    public init() {
        super.init(formatString: "yyyy-MM-dd")
    }
}

public class GMTLongDateTransform: BaseDateTransform {
    public init() {
        super.init(formatString: "yyyy-MM-dd HH:mm:ss", isGMT: true)
    }
}

public class LongDateTransform: BaseDateTransform {
    public init() {
        super.init(formatString: "yyyy-MM-dd HH:mm:ss zzzz")
    }
}
