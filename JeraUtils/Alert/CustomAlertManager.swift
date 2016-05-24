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
    private var alertQueue = [UIView]()
    
    public func showAlert(alertView: UIView){
        if alertWindow == nil{
            alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
            if let alertWindow = alertWindow{
                let alertViewController = BaseAlertViewController()
                
                alertViewController.alertView = alertView
                
                alertWindow.rootViewController = alertViewController
                
                alertWindow.windowLevel = UIWindowLevelAlert
                
                mainWindow = UIApplication.sharedApplication().keyWindow
                
                alertWindow.makeKeyAndVisible()
                
                //Animation
//                alertView.transform = CGAffineTransformMakeTranslation(0, alertWindow.bounds.size.height)
//                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
//                    alertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
//                    alertView.transform = CGAffineTransformIdentity
//                    }, completion: nil)
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    alertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    }, completion: nil)
            }
        }else{
            alertQueue.append(alertView)
        }
    }
    
    /**
     Dismiss a view being or about to be shown by the CustomAlertManager
     - parameter alertView: The view to be dismissed
     - parameter completion: Block called when alert has been closed
     */
    public func dismissAlertView(alertView: UIView?, completion: ((finished: Bool) -> Void)? = nil){
        guard let alertView = alertView else {
            return
        }
        
        if let alertWindow = alertWindow{
            if alertView == (alertWindow.rootViewController as! BaseAlertViewController).alertView {
                dismissCurrentAlert(completion)
            }else{
                if let customViewIndex = alertQueue.indexOf(alertView) {
                    alertQueue.removeAtIndex(customViewIndex)
                }
            }
            

        }
    }
    
    public func dismissCurrentAlert(completion: ((finished: Bool) -> Void)? = nil){
        if let alertWindow = alertWindow{
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                alertWindow.alpha = 0
                }, completion: { [weak self] (finished) -> Void in
                    if let strongSelf = self{
                        strongSelf.alertWindow?.rootViewController?.view.endEditing(true)
                        strongSelf.mainWindow?.makeKeyWindow()
                        strongSelf.alertWindow = nil
                        
                        if let alertToPresent = strongSelf.alertQueue.first{
                            strongSelf.showAlert(alertToPresent)
                            strongSelf.alertQueue.removeAtIndex(0)
                        }
                        completion?(finished: finished)
                    }
                    
                })
        }
    }
    
    public func dismissAllAlerts(){
        alertQueue = [UIView]()
        dismissCurrentAlert()
    }
}
