//
//  AlertManager.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 1/15/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import RxSwift
import Moya

public enum AlertManagerOption {
    case Button(title: String, index: Int)
    case Retry
    case Cancel
    case DontShow
}

//extension ObservableType {
//    func showAlert(title title: String, message: String? = nil, options: [String]? = nil, hasCancel: Bool = false, preferredStyle: UIAlertControllerStyle = .Alert, presenterViewController: UIViewController?) -> Observable<AlertManagerOption> {
//        return flatMapLatest { _ -> Observable<AlertManagerOption> in
//            if let presenterViewController = presenterViewController{
//                return AlertManager.sharedManager.alert(title: title, message: message, options: options, hasCancel: hasCancel, preferredStyle: preferredStyle, presenterViewController: presenterViewController)
//            }else{
//                return Observable.just(.DontShow)
//            }
//        }
//    }
//
//
//}
//
//extension ObservableType where E == ErrorType? {
//    func showError(presenterViewController presenterViewController: UIViewController?) -> Observable<AlertManagerOption> {
//        return flatMapLatest { errorType -> Observable<AlertManagerOption> in
//            if let errorType = errorType, presenterViewController = presenterViewController {
//                return AlertManager.sharedManager.error(errorType, presenterViewController: presenterViewController)
//            }
//            return Observable.just(.DontShow)
//        }
//    }
//}

public struct AlertOption {
    public var title: String
    public var style: UIAlertActionStyle
    
    public init(title: String, style: UIAlertActionStyle) {
        self.title = title
        self.style = style
    }
}

public class AlertManager {
    static public var sharedManager = AlertManager()

    /**
     Creates an alert and shows it on your screen.
     - parameter title: The title that will be shown on the top of the alert view.
     - parameter message: The message to be displayed inside the alert view box.
     - parameter allertOptions: An array of AlertOption which are composed of a title and a style.
     - parameter hasCancle: Boolean indicating whether there will be a cancel option.
     - parameter preferredStyle: The style the AlertController is going the be.
     - parameter presenterViewController: The controller which is going to present the alert.
     - retuns: Observable AlertManagerOption
     */
    public func alert(title title: String?, message: String? = nil, alertOptions: [AlertOption]?, hasCancel: Bool = false, preferredStyle: UIAlertControllerStyle = .alert, presenterViewController: UIViewController?) -> Observable<AlertManagerOption> {

        return Observable.create({ (observer) -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

            if let options = alertOptions {
                for (index, option) in options.enumerated() {
                    let index = index
                    let optionAction = UIAlertAction(title: option.title, style: option.style, handler: { (alertAction) -> Void in
                        observer.onNext(.Button(title: alertAction.title!, index: index))
                        observer.onCompleted()
                    })
                    alertController.addAction(optionAction)
                }
            } else {
                if !hasCancel {
                    let okAction = UIAlertAction(title: I18n(localizableString: "alertmanager-ok", defaultString: "OK"), style: .default, handler: { (alertAction) -> Void in
                        observer.onNext(.Cancel)
                        observer.onCompleted()
                    })
                    alertController.addAction(okAction)
                }
            }

            if hasCancel {
                let cancelAction = UIAlertAction(title: I18n(localizableString: "alertmanager-cancel", defaultString: "Cancelar"), style: .cancel, handler: { (alertAction) -> Void in
                    observer.onNext(.Cancel)
                    observer.onCompleted()
                })
                alertController.addAction(cancelAction)
            }

            if let presenterViewController = presenterViewController{
                presenterViewController.present(alertController, animated: true, completion: nil)
            }else if let presenterViewController = Helper.topViewController(){
                presenterViewController.present(alertController, animated: true, completion: nil)
            }else{
                print("não existe controllers para apresentar o alert")
            }
            
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        })
    }

    public func alert(title title: String?, message: String? = nil, options: [String]? = nil, hasCancel: Bool = false, preferredStyle: UIAlertControllerStyle = .alert, presenterViewController: UIViewController?) -> Observable<AlertManagerOption> {

        var alertOptions: [AlertOption]?
        if let options = options {
            alertOptions = options.map({ (optionTitle) -> AlertOption in
                return AlertOption(title: optionTitle, style: .default)
            })
        }

        return alert(title: title,
            message: message,
            alertOptions: alertOptions,
            hasCancel: hasCancel,
            preferredStyle: preferredStyle,
            presenterViewController: presenterViewController)
    }

    static public let RetryKey = "RetryKey"
    static public let ShowKey = "ShowKey"
    class public func createErrorForAlert(domain: String, code: Int = 0, localizedDescription: String, alertRetry: Bool = true, alertShow: Bool = true) -> NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription, RetryKey: alertRetry, ShowKey: alertShow])
    }

    /**
     Creates an error alert and shows it on your screen.
     - parameter errorType: The type of the error you want the alert the user of.
     - parameter preferredStyle: The style the AlertController is going the be.
     - parameter presenterViewController: The controller which is going to present the error alert.
     - retuns: Observable AlertManagerOption
     */
    public func error(errorType: Swift.Error, preferredStyle: UIAlertControllerStyle = .alert, presenterViewController: UIViewController? = nil) -> Observable<AlertManagerOption> {
        return Observable.create({ (observer) -> Disposable in
            let error = translateMoyaError(errorType: errorType)

            if let show = error.userInfo[AlertManager.ShowKey] as? Bool, !show {
                observer.onNext(.DontShow)
                observer.onCompleted()
                return Disposables.create()
            }

            var title = I18n(localizableString: "alertmanager-default-error-title", defaultString: "Ops...")
            if error.domain == NSURLErrorDomain {
                
                switch error.code {
                case NSURLErrorCancelled:
                    observer.onNext(.DontShow)
                    observer.onCompleted()
                    return Disposables.create()
                default:
                    title = I18n(localizableString: "alertmanager-connection-error-title", defaultString: "Problemas com a rede")
                }
            }

            let showRetry: Bool
            if let retry = error.userInfo[AlertManager.RetryKey] as? Bool, !retry {
                showRetry = false
            } else {
                showRetry = true
            }

            let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: preferredStyle)
            
            if error.localizedDescription == "Not Found" {
                alertController.message = "Não foi possível completar a operação. Por favor entre em contato com o suporte técnico."
            }

            if showRetry {
                let retryAction = UIAlertAction(title: I18n(localizableString: "alertmanager-try-again", defaultString: "Tentar novamente"), style: .default, handler: { (_) -> Void in
                    observer.onNext(.Retry)
                    observer.onCompleted()
                })
                alertController.addAction(retryAction)
            }

            let cancelAction = UIAlertAction(title: (showRetry) ? I18n(localizableString: "alertmanager-cancel", defaultString: "Cancelar") : I18n(localizableString: "alertmanager-ok", defaultString: "OK"), style: .default, handler: { (_) -> Void in
                observer.onNext(.Cancel)
                observer.onCompleted()
            })
            alertController.addAction(cancelAction)

            if let presenterViewController = presenterViewController{
                presenterViewController.present(alertController, animated: true, completion: nil)
            }else if let presenterViewController = Helper.topViewController(){
                presenterViewController.present(alertController, animated: true, completion: nil)
            }else{
                print("não existe controllers para apresentar o alert")
            }

            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        })
    }
}
