//
//  CustomAlertManager.swift
//  Pods
//
//  Created by Alessandro Nakamuta on 5/24/16.
//
//

import UIKit

public class CustomAlertManager {
    public static var sharedManager = CustomAlertManager()
    
    private var mainWindow: UIWindow?
    
    private var alertWindow: UIWindow?
    private var alertQueue = [BaseAlertView]()
    
    public func showAlert(alertView: BaseAlertView){
        if let alertWindow = alertWindow{
            if let baseAlertView = alertWindow.rootViewController as? BaseAlertViewController{
                if baseAlertView.alertView != alertView{
                    if alertQueue.index(of: alertView) != nil {
                        alertQueue.append(alertView)
                    }
                }
            }else{
                if alertQueue.index(of: alertView) != nil {
                    alertQueue.append(alertView)
                }
            }
        }else{
            alertWindow = UIWindow(frame: UIScreen.main.bounds)
            if let alertWindow = alertWindow{
                let alertViewController = BaseAlertViewController()
                
                alertViewController.alertView = alertView
                alertView.baseAlertViewController = alertViewController
                
                alertWindow.rootViewController = alertViewController
                
                alertWindow.windowLevel = UIWindowLevelAlert
                
                mainWindow = UIApplication.shared.keyWindow
                
                alertWindow.makeKeyAndVisible()
                
                //Animation
                //                alertView.transform = CGAffineTransformMakeTranslation(0, alertWindow.bounds.size.height)
                //                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                //                    alertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
                //                    alertView.transform = CGAffineTransformIdentity
                //                    }, completion: nil)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    alertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    }, completion: nil)
            }
        }
    }
    
    /**
     Dismiss a view being or about to be shown by the CustomAlertManager
     - parameter alertView: The view to be dismissed
     - parameter completion: Block called when alert has been closed
     */
    public func dismissAlertView(alertView: BaseAlertView?, completion: ((_ finished: Bool) -> Void)? = nil){
        guard let alertView = alertView else {
            return
        }
        
        if let alertWindow = alertWindow{
            if alertView == (alertWindow.rootViewController as! BaseAlertViewController).alertView {
                dismissCurrentAlert(completion: completion)
            }else{
                if let customViewIndex = alertQueue.index(of: alertView) {
                    alertQueue.remove(at: customViewIndex)
                }
            }
            

        }
    }
    
    public func dismissCurrentAlert(completion: ((_ finished: Bool) -> Void)? = nil){
        if let alertWindow = alertWindow{
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                alertWindow.alpha = 0
                }, completion: { [weak self] (finished) -> Void in
                    if let strongSelf = self{
                        strongSelf.alertWindow?.rootViewController?.view.endEditing(true)
                        strongSelf.mainWindow?.makeKey()
                        strongSelf.alertWindow = nil
                        
                        if let alertToPresent = strongSelf.alertQueue.first{
                            strongSelf.showAlert(alertView: alertToPresent)
                            strongSelf.alertQueue.remove(at: 0)
                        }
                        completion?(finished)
                    }
                    
                })
        }
    }
    
    public func dismissAllAlerts(){
        alertQueue = [BaseAlertView]()
        dismissCurrentAlert()
    }
}
