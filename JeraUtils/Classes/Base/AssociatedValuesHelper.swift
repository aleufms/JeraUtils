//
//  AssociatedValuesHelper.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/18/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import ObjectiveC

final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

private func lift<T>(x: T) -> Lifted<T>  {
    return Lifted(x)
}

func setAssociatedObject<T>(object: AnyObject, value: T?, associativeKey: UnsafePointer<Void>, policy: objc_AssociationPolicy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    guard value != nil else{
        objc_setAssociatedObject(object, associativeKey, nil,  policy)
        return
    }
    
    if let v = value as? AnyObject {
        objc_setAssociatedObject(object, associativeKey, v,  policy)
    }
    else {
        objc_setAssociatedObject(object, associativeKey, lift(value),  policy)
    }
}

func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafePointer<Void>) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    }
    else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
        return v.value
    }
    else {
        return nil
    }
}

func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafePointer<Void>, policy: objc_AssociationPolicy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC, initialiser: () -> T) -> T {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    }
    else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
        return v.value
    }
    else {
        let initialValue = initialiser()
        setAssociatedObject(object, value: initialValue, associativeKey: associativeKey, policy: policy)
        return initialValue
    }
}

//Example:
//extension UIView {
//    
//    private struct AssociatedKey {
//        static var viewExtension = "viewExtension"
//    }
//    
//    var referenceTransform: CGAffineTransform? {
//        get {
//            return getAssociatedObject(self, associativeKey: &AssociatedKey.viewExtension)
//        }
//        
//        set {
//            if let value = newValue {
//                setAssociatedObject(self, value: value, associativeKey: &AssociatedKey.viewExtension)
//            }
//        }
//    }
//}