//
//  FieldValidator.swift
//  Pods
//
//  Created by Alessandro Nakamuta on 5/12/16.
//
//

import RxSwift
import Material
import RxCocoa

public extension TextField {
    
    public var rx_errorText: AnyObserver<String?> {
        return UIBindingObserver(UIElement: self, binding: { (control, value) in
            if let value = value{
                control.detail = value
            }else{
                control.detail = nil
            }
        }).asObserver()
    }
    
}

public extension ObservableType where E == String {
    public func trim() -> Observable<String> {
        return map({ (text) -> String in
            return text.trimmed
        })
    }
    
    public func validate(fieldValidations: [FieldValidationError]) -> Observable<[FieldValidationError]?> {
        
        return flatMap({ (text) -> Observable<[FieldValidationError]?> in
            var otherTextSignal: Variable<String>?
            for fieldValidation in fieldValidations{
                switch fieldValidation{
                case .Equal(let text):
                    otherTextSignal = text
                default:
                    break
                }
            }
            
            if let otherTextSignal = otherTextSignal{
                return otherTextSignal.asObservable().map({ (text2) -> [FieldValidationError]? in
                    var fieldValidationErrors = [FieldValidationError]()
                    
                    for fieldValidation in fieldValidations{
                        if !fieldValidation.isValid(text: text){
                            fieldValidationErrors.append(fieldValidation)
                        }
                    }
                    
                    if fieldValidationErrors.count == 0{
                        return nil
                    }
                    
                    //If field is empty, only show required error
                    if fieldValidationErrors.contains(.Required){
                        return [.Required]
                    }
                    
                    return fieldValidationErrors
                })
            }
            
            return Observable.create({ (observer) -> Disposable in
                var fieldValidationErrors = [FieldValidationError]()
                
                for fieldValidation in fieldValidations{
                    if !fieldValidation.isValid(text: text){
                        fieldValidationErrors.append(fieldValidation)
                    }
                }
                
                if fieldValidationErrors.count == 0{
                    observer.onNext(nil)
                    observer.onCompleted()
                }
                
                //If field is empty, only show required error
                if fieldValidationErrors.contains(.Required){
                    observer.onNext([.Required])
                    observer.onCompleted()
                }
                
                observer.onNext(fieldValidationErrors)
                observer.onCompleted()
                
                return Disposables.create()
            })
        })
    }
}

public extension ObservableType where E == [FieldValidationError]? {
    public func validatorDescription() -> Observable<String?> {
        return map({ (fieldValidatorErrors) -> String? in
            if let fieldValidatorErrors = fieldValidatorErrors{
                let fieldValidatorErrorStrings = fieldValidatorErrors.map({ (fieldValidatorError) -> String in
                    return fieldValidatorError.description()
                })
                
                return fieldValidatorErrorStrings.joined(separator: ", ")
            }
            return nil
        })
    }
}


public enum FieldValidationError: Equatable{
    case Required
    case MinLength(count: Int)
    case MaxLength(count: Int)
    case ExactLength(count: Int)
    case Email
    case Cpf
    case Equal(variable: Variable<String>)
    case Custom(isValidBlock: (String) -> Bool, invalidText: String)
    
    public func isValid(text: String) -> Bool{
        switch self {
        case .Required:
            return text.characters.count > 0
        case .MinLength(let count):
            return text.characters.count >= count
        case .MaxLength(let count):
            return text.characters.count <= count
        case .ExactLength(let count):
            return text.characters.count == count
        case .Email:
            return text.isValidEmail()
        case .Cpf:
            return CPF.validate(cpf: text)
        case .Equal(let variable):
            return text == variable.value
        case .Custom(let parameters):
            return parameters.isValidBlock(text)
        }
    }
    
    public func description() -> String{
        switch self {
        case .Required:
            return "Campo requerido"
        case .MinLength(let count):
            return "Campo deve ter mais que \(count) caracteres"
        case .MaxLength(let count):
            return "Campo deve ter menos que \(count) caracteres"
        case .ExactLength(let count):
            return "Campo deve ter exatamente \(count) caracteres"
        case .Email:
            return "Não é um email válido"
        case .Cpf:
            return "CPF Inválido"
        case .Equal:
            return "Campos estão diferentes"
        case .Custom(let parameters):
            return parameters.invalidText
        }
    }
}

public func ==(a: FieldValidationError, b: FieldValidationError) -> Bool {
    switch (a, b) {
    case (.MinLength, .MinLength): return true
    case (.MaxLength, .MaxLength): return true
    case (.ExactLength, .ExactLength): return true
    case (.Required, .Required): return true
    case (.Email, .Email): return true
    case (.Cpf, .Cpf): return true
    case (.Equal, .Equal): return true
    default: return false
    }
}
