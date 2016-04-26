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
    var title: String
    var style: UIAlertActionStyle
}

public class AlertManager {
    static public var sharedManager = AlertManager()

    public func alert(title title: String?, message: String? = nil, alertOptions: [AlertOption]?, hasCancel: Bool = false, preferredStyle: UIAlertControllerStyle = .Alert, presenterViewController: UIViewController) -> Observable<AlertManagerOption> {

        return Observable.create({ (observer) -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

            if let options = alertOptions {
                for (index, option) in options.enumerate() {
                    let index = index
                    let optionAction = UIAlertAction(title: option.title, style: option.style, handler: { (alertAction) -> Void in
                        observer.onNext(.Button(title: alertAction.title!, index: index))
                        observer.onCompleted()
                    })
                    alertController.addAction(optionAction)
                }
            } else {
                if !hasCancel {
                    let okAction = UIAlertAction(title: I18n("alertmanager-ok", defaultString: "OK"), style: .Default, handler: { (alertAction) -> Void in
                        observer.onNext(.Cancel)
                        observer.onCompleted()
                    })
                    alertController.addAction(okAction)
                }
            }

            if hasCancel {
                let cancelAction = UIAlertAction(title: I18n("alertmanager-cancel", defaultString: "Cancelar"), style: .Cancel, handler: { (alertAction) -> Void in
                    observer.onNext(.Cancel)
                    observer.onCompleted()
                })
                alertController.addAction(cancelAction)
            }

            presenterViewController.presentViewController(alertController, animated: true, completion: nil)

            return AnonymousDisposable {
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }

    public func alert(title title: String?, message: String? = nil, options: [String]? = nil, hasCancel: Bool = false, preferredStyle: UIAlertControllerStyle = .Alert, presenterViewController: UIViewController) -> Observable<AlertManagerOption> {

        var alertOptions: [AlertOption]?
        if let options = options {
            alertOptions = options.map({ (optionTitle) -> AlertOption in
                return AlertOption(title: optionTitle, style: .Default)
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

    public func error(errorType: ErrorType, preferredStyle: UIAlertControllerStyle = .Alert, presenterViewController: UIViewController) -> Observable<AlertManagerOption> {
        return Observable.create({ (observer) -> Disposable in
            let error = translateMoyaError(errorType)

            if let show = error.userInfo[AlertManager.ShowKey] as? Bool where !show {
                observer.onNext(.DontShow)
                observer.onCompleted()
                return NopDisposable.instance
            }

            var title = I18n("alertmanager-default-error-title", defaultString: "Ops...")
            if error.domain == NSURLErrorDomain {
                switch error.code {
                case NSURLErrorCancelled:
                    observer.onNext(.DontShow)
                    observer.onCompleted()
                    return NopDisposable.instance
                default:
                    title = I18n("alertmanager-connection-error-title", defaultString: "Problemas com a rede")
                }
            }

            let showRetry: Bool
            if let retry = error.userInfo[AlertManager.RetryKey] as? Bool where !retry {
                showRetry = false
            } else {
                showRetry = true
            }

            let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: preferredStyle)

            if showRetry {
                let retryAction = UIAlertAction(title: I18n("alertmanager-try-again", defaultString: "Tentar novamente"), style: .Default, handler: { (_) -> Void in
                    observer.onNext(.Retry)
                    observer.onCompleted()
                })
                alertController.addAction(retryAction)
            }

            let cancelAction = UIAlertAction(title: (showRetry) ? I18n("alertmanager-cancel", defaultString: "Cancelar") : I18n("alertmanager-ok", defaultString: "OK"), style: .Default, handler: { (_) -> Void in
                observer.onNext(.Cancel)
                observer.onCompleted()
            })
            alertController.addAction(cancelAction)

            presenterViewController.presentViewController(alertController, animated: true, completion: nil)

            return AnonymousDisposable {
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
}
