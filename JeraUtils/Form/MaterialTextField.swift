//
//  MaterialTextField.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/19/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import Material
import NSStringMask
import RxCocoa
import RxSwift

public enum TextFieldMask {
    case CPF
    case Phone
    case Password
    case CreditCard
    case CVV
    case CardExpireDate
    case CEP

    public func maskForString(text: String) -> NSStringMask {
        switch self {
        case .CPF:
            return NSStringMask(pattern: "(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})", placeholder: "_")
        case .Phone:
            switch text.characters.count{
            case 0...8:
                return NSStringMask(pattern: "(\\d{4})-(\\d{4})", placeholder: "_")
            case 9...10:
                return NSStringMask(pattern: "\\((\\d{2})\\) (\\d{4})-(\\d{4})", placeholder: "_")
            default:
                return NSStringMask(pattern: "\\((\\d{2})\\) (\\d{5})-(\\d{4})", placeholder: "_")
            }
        case .Password:
            return NSStringMask(pattern: "(\\d{4})", placeholder: "_")
        case .CreditCard:
            switch text.characters.count{
            case 13:
                return NSStringMask(pattern: "(\\d{4}) (\\d{4}) (\\d{4}) (\\d{1})", placeholder: "_")
            case 14:
                return NSStringMask(pattern: "(\\d{4}) (\\d{4}) (\\d{4}) (\\d{2})", placeholder: "_")
            case 15:
                return NSStringMask(pattern: "(\\d{4}) (\\d{4}) (\\d{4}) (\\d{3})", placeholder: "_")
            default:
                return NSStringMask(pattern: "(\\d{4}) (\\d{4}) (\\d{4}) (\\d{4})", placeholder: "_")
            }
        case .CVV:
            switch text.characters.count{
            case 0...3:
                return NSStringMask(pattern: "(\\d{3})", placeholder: "_")
            default:
                return NSStringMask(pattern: "(\\d{4})", placeholder: "_")
            }
        case .CardExpireDate:
            return NSStringMask(pattern: "(\\d{2})/(\\d{2})", placeholder: "_")
        case .CEP:
            return NSStringMask(pattern: "(\\d{5})-(\\d{3})", placeholder: "_")
        }
    }

    public func format(text: String?) -> String {
        if let text = text {
            return maskForString(text: text).format(text)
        }
        return ""
    }

    public func validCharactersForString(text: String?) -> String {
        if let text = text {
            return maskForString(text: text).validCharacters(for: text)
        }
        return ""
    }

}

//class MaterialMaskTextFieldViewModel{
//    var value: Variable<String>
//}

//public extension UITextField {
//
//    private struct AssociatedKey {
//        static var mask = "mask"
//        static var maskDisposeBag = "maskDisposeBag"
//    }
//
//    public var mask: TextFieldMask? {
//        get {
//            return getAssociatedObject(self, associativeKey: &AssociatedKey.mask)
//        }
//
//        set {
//            setAssociatedObject(self, value: newValue, associativeKey: &AssociatedKey.mask)
//            if let value = newValue {
//                maskInit()
//            }else{
//                removeMaskInit()
//            }
//        }
//    }
//    
//    private var maskDisposeBag: DisposeBag? {
//        get {
//            return getAssociatedObject(self, associativeKey: &AssociatedKey.maskDisposeBag)
//        }
//        
//        set {
//            setAssociatedObject(self, value: newValue, associativeKey: &AssociatedKey.maskDisposeBag)
//        }
//    }
//    
//    private func maskInit() {
//        maskDisposeBag = DisposeBag()
//        
//        rx_text.subscribeNext { (text) in
//            
//        }
////        rx_value
////            .asObservable()
////            .map { (text) -> String in
////                if let mask = self.mask {
////                    if text.characters.count > 0 {
////                        return mask.format(text)
////                    } else {
////                        return ""
////                    }
////                } else {
////                    return text
////                }
////            }
////            //            .observeOn(MainScheduler.instance)
////            //            .subscribeNext({ [weak self] (text) -> Void in
////            //                if let strongSelf = self{
////            //                dispatch_async(dispatch_get_main_queue()) {
////            //                        strongSelf.text = text
////            //                    }
////            //                }
////            //            })
////            .bindTo(rx_text)
////            .addDisposableTo(disposeBag)
//        
//    }
//    
//    private func removeMaskInit() {
//    }
//}

//TODO: Fazer isso através de extension e não subclasse
public class MaterialMaskTextField: TextField, UITextFieldDelegate {

    public var textMask: TextFieldMask?

    var disposeBag = DisposeBag()
    public var rx_value = Variable<String>("")

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        delegate = self

        rx_value
            .asObservable()
            .map { (text) -> String in
                if let textMask = self.textMask {
                    if text.characters.count > 0 {
                        return textMask.format(text: text)
                    } else {
                        return ""
                    }
                } else {
                    return text
                }
            }
//            .observeOn(MainScheduler.instance)
//            .subscribeNext({ [weak self] (text) -> Void in
//                if let strongSelf = self{
//                dispatch_async(dispatch_get_main_queue()) {
//                        strongSelf.text = text
//                    }
//                }
//            })
            .bindTo(rx.text)
        .addDisposableTo(disposeBag)

    }

    deinit {
        self.delegate = nil
    }

    //MARK: UITextFieldDelegate
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if let textMask = textMask {
            var finalRawText: String
            if string.characters.count == 0 {
                finalRawText = textMask.validCharactersForString(text: textField.text)
                if finalRawText.characters.count > 0 {
                    finalRawText.remove(at: finalRawText.index(before: finalRawText.endIndex))
                }
            } else {
                let startRawText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                finalRawText = textMask.validCharactersForString(text: startRawText)
            }
            
//            rx_text.asObserver().onNext(mask.format(finalRawText))
            rx_value.value = finalRawText
            return false
        }
        return true
    }
}

//extension UITextField{
//    private struct AssociatedKey {
//        static var maskFormatExtension = "maskFormatExtension"
//    }
//
//    var maskFormatString: String? {
//        get {
//            return getAssociatedObject(self, associativeKey: &AssociatedKey.maskFormatExtension)
//        }
//
//        set {
//            if let value = newValue {
//                rx_text.takeUntil(self.rx_deallocated).subscribeNext({ (text) -> Void in
//                    print("buu \(text)")
//                    self.text = "abcde"
//                })
//
//                setAssociatedObject(self, value: value, associativeKey: &AssociatedKey.maskFormatExtension)
//            }
//        }
//    }
//
//}

public class MaterialDateTextField: TextField, UITextFieldDelegate {

    public var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateStyle = .long
        return formatter
    }()

    public var datePickerDisposeBag = DisposeBag()
    public var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        datePicker.datePickerMode = UIDatePickerMode.date

        return datePicker
    }()

    deinit {
        self.delegate = nil
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        datePicker.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] (_) -> Void in
            self?.datePickerUpdated()
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(datePickerDisposeBag)

        rx_value
            .asObservable()
            .map { [weak self] (date) -> String in
                if let strongSelf = self, let date = date {
                    return strongSelf.dateFormatter.string(from: date as Date)
                }

                return ""
            }
            .bindTo(rx.text)
            .addDisposableTo(disposeBag)

        inputView = datePicker
        delegate = self
    }


    var disposeBag = DisposeBag()
    let rx_value = Variable<NSDate?>(nil)

    public func clear() {
        rx_value.value = nil
    }

    private func datePickerUpdated() {
        rx_value.value = datePicker.date as NSDate?
    }

    //MARK: UITextFieldDelegate
    public func textFieldDidBeginEditing(textField: UITextField) {
        if let date = rx_value.value {
            datePicker.date = date as Date
        } else {
            rx_value.value = NSDate()
            datePicker.date = NSDate() as Date
        }
    }

    public func textFieldShouldClear(textField: UITextField) -> Bool {
        rx_value.value = nil
        return false
    }

}
