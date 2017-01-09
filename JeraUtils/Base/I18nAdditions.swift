//
//  I18nAdditions.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 1/19/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit

//extension String{
//    func i18n(args: [CVarArgType]? = nil, defaultString: String? = nil) -> String{
//        let localizedString = NSLocalizedString(self, comment: "")
//
//        if let args = args{
//            if let defaultString = defaultString where localizedString == self{
//                return String(format: defaultString, arguments: args)
//            }
//            return String(format: localizedString, arguments: args)
//        }
//
//        return localizedString
//    }
//}

public func I18n(localizableString: String, defaultString: String? = nil, args: [CVarArg]? = nil) -> String {
    let localizedString = NSLocalizedString(localizableString, comment: "")

    if let args = args {
        if let defaultString = defaultString, localizedString == localizableString {
            return String(format: defaultString, arguments: args)
        }
        return String(format: localizedString, arguments: args)
    } else {
        if let defaultString = defaultString, localizedString == localizableString {
            return String(format: defaultString)
        }
        return String(format: localizedString)
    }
}
