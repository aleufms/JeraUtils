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

public  extension ObservableType where E == String {
    public func trim() -> Observable<String> {
        return map({ (text) -> String in
            return text.trim()
        })
    }
    
    public func validate(fieldValidations: [FieldValidationError]) -> Observable<[FieldValidationError]?> {
        return map({ (text) -> [FieldValidationError]? in
            var fieldValidationErrors = [FieldValidationError]()
            
            for fieldValidation in fieldValidations{
                if !fieldValidation.isValid(text){
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
}

public extension ObservableType where E == [FieldValidationError]? {
    public func validatorDescription() -> Observable<String?> {
        return map({ (fieldValidatorErrors) -> String? in
            if let fieldValidatorErrors = fieldValidatorErrors{
                let fieldValidatorErrorStrings = fieldValidatorErrors.map({ (fieldValidatorError) -> String in
                    return fieldValidatorError.description()
                })
                
                return fieldValidatorErrorStrings.joinWithSeparator(", ")
            }
            return nil
        })
    }
}


public enum FieldValidationError: Equatable{
    case Required
    case Length(count: Int)
    case Email
    case Cpf
    case Equal
    
    public func isValid(text: String) -> Bool{
        switch self {
        case .Required:
            return text.characters.count > 0
        case .Length(let count):
            return text.characters.count >= count
        case .Email:
            return text.isValidEmail()
        case .Cpf:
            return CPF.validate(text)
        case .Equal:
            return false
        }
    }
    
    public func description() -> String{
        switch self {
        case .Required:
            return "Campo requerido"
        case .Length(let count):
            return "Campo deve ter mais que \(count) caracteres"
        case .Email:
            return "Não é um email válido"
        case .Cpf:
            return "CPF Inválido"
        case .Equal:
            return "Campos estão diferentes"
        }
    }
}

public func ==(a: FieldValidationError, b: FieldValidationError) -> Bool {
    switch (a, b) {
    case (.Length, .Length): return true
    case (.Required, .Required): return true
    case (.Email, .Email): return true
    default: return false
    }
}