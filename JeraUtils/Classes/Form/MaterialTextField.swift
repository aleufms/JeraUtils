//
//  MaterialTextField.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/19/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import MK
import NSStringMask
import RxCocoa
import RxSwift

enum TextFieldMask {
    case CPF
    case Phone
    case Password
    case CreditCard
    case CVV
    case CardExpireDate
    case CEP
    
    func maskForString(text: String) -> NSStringMask{
        switch self{
        case .CPF:
            return NSStringMask(pattern: "(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})", placeholder: "_")
        case .Phone:
            if text.characters.count <= 8{
                return NSStringMask(pattern: "(\\d{4})-(\\d{4})", placeholder: "_")
            }else if text.characters.count <= 10{
                return NSStringMask(pattern: "\\((\\d{2})\\) (\\d{4})-(\\d{4})", placeholder: "_")
            }else{
                return NSStringMask(pattern: "\\((\\d{2})\\) (\\d{5})-(\\d{4})", placeholder: "_")
            }
        case .Password:
            return NSStringMask(pattern: "(\\d{4})", placeholder: "_")
        case .CreditCard:
            return NSStringMask(pattern: "(\\d{4}) (\\d{4}) (\\d{4}) (\\d{4})", placeholder: "_")
        case .CVV:
            return NSStringMask(pattern: "(\\d{3})", placeholder: "_")
        case .CardExpireDate:
            return NSStringMask(pattern: "(\\d{2})/(\\d{4})", placeholder: "_")
        case .CEP:
            return NSStringMask(pattern: "(\\d{5})-(\\d{3})", placeholder: "_")
        }
    }
    
    func format(text: String?) -> String{
        if let text = text{
            return maskForString(text).format(text)
        }
        return ""
    }
    
    func validCharactersForString(text: String?) -> String{
        if let text = text{
            return maskForString(text).validCharactersForString(text)
        }
        return ""
    }
    
}

//class MaterialMaskTextFieldViewModel{
//    var value: Variable<String>
//}

//TODO: Fazer isso através de extension e não subclasse
class MaterialMaskTextField: TextField, UITextFieldDelegate {
    
    var mask: TextFieldMask?
    
    var disposeBag = DisposeBag()
    var rx_value = Variable<String>("")
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        delegate = self
        
        rx_value
            .asObservable()
            .map { (text) -> String in
                if let mask = self.mask{
                    if text.characters.count > 0{
                        return mask.format(text)
                    }else{
                        return ""
                    }
                }else{
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
            .bindTo(rx_text)
        .addDisposableTo(disposeBag)
        
    }
    
    deinit{
        self.delegate = nil
    }
    
    //MARK: UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        if let mask = mask{
            var finalRawText: String
            if string.characters.count == 0{
                finalRawText = mask.validCharactersForString(textField.text)
                if finalRawText.characters.count > 0{
                    finalRawText.removeAtIndex(finalRawText.endIndex.predecessor())
                }
            }else{
                let startRawText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
                finalRawText = mask.validCharactersForString(startRawText)
            }
            
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

class MaterialDateTextField: TextField, UITextFieldDelegate {

    var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")
        formatter.dateStyle = .LongStyle
        return formatter
    }()
    
    var datePickerDisposeBag = DisposeBag()
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone(name: "UTC")
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        return datePicker
    }()
    
    deinit{
        self.delegate = nil
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        datePicker.rx_controlEvent(.ValueChanged).subscribeNext({ [weak self] (_) -> Void in
            self?.datePickerUpdated()
            }).addDisposableTo(datePickerDisposeBag)
        
        rx_value
            .asObservable()
            .map { [weak self] (date) -> String in
                if let strongSelf = self, date = date{
                    return strongSelf.dateFormatter.stringFromDate(date)
                }
                
                return ""
            }
            .bindTo(rx_text)
            .addDisposableTo(disposeBag)
        
        inputView = datePicker
        delegate = self
    }
    
    
    var disposeBag = DisposeBag()
    let rx_value = Variable<NSDate?>(nil)
    
    func clear(){
        rx_value.value = nil
    }
    
    private func datePickerUpdated(){
        rx_value.value = datePicker.date
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField){
        if let date = rx_value.value{
            datePicker.date = date
        }else{
            rx_value.value = NSDate()
            datePicker.date = NSDate()
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool{
        rx_value.value = nil
        return false
    }
    
}