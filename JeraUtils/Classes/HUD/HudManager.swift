//
//  HudManager.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 9/16/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit

struct Hud{
    let customView: UIView
    let dismissAfter: Double?
    let userInteractionEnabled: Bool
    let customLayout: ((containerView: UIView, customView: UIView) -> ())?
}

class HudManager {
    static var sharedManager = HudManager()

    private var hudWindow: UIWindow?
    
    private var currentView: UIView?
    private var viewQueue = [Hud]()

    func showCustomView(customView: UIView, dismissAfter: Double? = nil, userInteractionEnabled: Bool = true, customLayout: ((containerView: UIView, customView: UIView) -> ())? = nil) {
        if hudWindow == nil{
            hudWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
            if let hudWindow = hudWindow{
                currentView = customView
                
                let hudViewController = HudViewController()
                
                if let customLayout = customLayout{
                    hudViewController.customViewLayout = customLayout
                }
                
                hudViewController.customView = customView
                
                hudWindow.userInteractionEnabled = userInteractionEnabled
                
                hudWindow.rootViewController = hudViewController
                
                hudWindow.windowLevel = UIWindowLevelAlert + 1
                
                hudWindow.makeKeyAndVisible()
                
                //Animation
                customView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                let initialHudAlpha = customView.alpha
                customView.alpha = 0
                hudViewController.view.backgroundColor = UIColor(white: 0, alpha: 0)
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    if userInteractionEnabled{
                        hudViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    }
                    customView.alpha = initialHudAlpha
                    customView.transform = CGAffineTransformIdentity
                    }, completion: nil)
                
                if let dismissAfter = dismissAfter {
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(dismissAfter * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
                        self?.dismissHudView(customView)
                    }
                }
            }
        }else{
            viewQueue.append(Hud(customView: customView, dismissAfter: dismissAfter, userInteractionEnabled: userInteractionEnabled, customLayout: customLayout))
        }
    }
    
    func dismissHudView(hudView: UIView){
        if hudView == currentView{
            dismissCurrentView()
        }else{
            if let customViewIndex = viewQueue.map({ return $0.customView }).indexOf(hudView){
                viewQueue.removeAtIndex(customViewIndex)
            }
        }
    }
    
    func dismissCurrentView(completion: ((finished: Bool) -> Void)? = nil){
        if let hudWindow = hudWindow{
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                hudWindow.alpha = 0
                }, completion: { [weak self] (finished) -> Void in
                    if let strongSelf = self{
                        hudWindow.resignKeyWindow()
                        strongSelf.hudWindow = nil
                        
                        if let hudToPresent = strongSelf.viewQueue.first{
                            strongSelf.showCustomView(hudToPresent.customView, dismissAfter: hudToPresent.dismissAfter, userInteractionEnabled: hudToPresent.userInteractionEnabled, customLayout: hudToPresent.customLayout)
                            strongSelf.viewQueue.removeAtIndex(0)
                        }
                        completion?(finished: finished)
                    }
            })
        }
    }
    
    func dismissAllAlerts(){
        viewQueue = []
        dismissCurrentView()
    }
}
