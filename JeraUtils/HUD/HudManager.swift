//
//  HudManager.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 9/16/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import RxSwift

struct Hud {
    let customView: UIView
    let dismissAfter: Double?
    let userInteractionEnabled: Bool
    let customLayout: ((_ containerView: UIView, _ customView: UIView) -> ())?
}

public class HudManager {
    public static var sharedManager = HudManager()

    private var hudWindow: UIWindow?

    private var currentView: UIView?
    private var viewQueue = [Hud]()

    /**
     Shows a custom view popup
     - parameter customView: The view to be shown
     - parameter dismissAfter: Seconds before the view is dismissed. If nil the dismissing should be handled by your code.
     - parameter userInteractionEnabled: Whether the user can interact with the view or not. Set true by default.
     - parameter customLayout: A block with a custom container view and a custom view with their constrains and layout alreay set. By default it will layout in the middle of the screen.
    */
    public func showCustomView(customView: UIView, dismissAfter: Double? = nil, userInteractionEnabled: Bool = true, customLayout: ((_ containerView: UIView, _ customView: UIView) -> ())? = nil) {
        if hudWindow == nil {
            hudWindow = UIWindow(frame: UIScreen.main.bounds)
            if let hudWindow = hudWindow {
                currentView = customView

                let hudViewController = HudViewController()

                if let customLayout = customLayout {
                    hudViewController.customViewLayout = customLayout
                }

                hudViewController.customView = customView

                hudWindow.isUserInteractionEnabled = userInteractionEnabled

                hudWindow.rootViewController = hudViewController

                hudWindow.windowLevel = UIWindowLevelAlert + 1

                hudWindow.makeKeyAndVisible()

                //Animation
                customView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                let initialHudAlpha = customView.alpha
                customView.alpha = 0
                hudViewController.view.backgroundColor = UIColor(white: 0, alpha: 0)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    if userInteractionEnabled {
                        hudViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    }
                    customView.alpha = initialHudAlpha
                    customView.transform = CGAffineTransform.identity
                    }, completion: nil)

                if let dismissAfter = dismissAfter {
//                    let delayTime = dispatch_time(dispatch_time_t(DispatchTime.now()), Int64(dismissAfter * Double(NSEC_PER_SEC)))
//                    dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
//                        self?.dismissHudView(hudView: customView)
//                    }
                }
            }
        } else {
            viewQueue.append(Hud(customView: customView, dismissAfter: dismissAfter, userInteractionEnabled: userInteractionEnabled, customLayout: customLayout))
        }
    }
    
    /**
     Dismiss a view being or about to be shown by the HUDManager
     - parameter hudView: The view to be dismissed
    */
    public func dismissHudView(hudView: UIView?) {
        guard let hudView = hudView else {
            return
        }
        
        if hudView == currentView {
            dismissCurrentView()
        } else {
            if let customViewIndex = viewQueue.map({ return $0.customView }).index(of: hudView) {
                viewQueue.remove(at: customViewIndex)
            }
        }
    }
    
    
    public func dismissCurrentView(completion: ((_ finished: Bool) -> Void)? = nil) {
        if let hudWindow = hudWindow {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                hudWindow.alpha = 0
                }, completion: { [weak self] (finished) -> Void in
                    if let strongSelf = self {
                        hudWindow.resignKey()
                        strongSelf.hudWindow = nil

                        if let hudToPresent = strongSelf.viewQueue.first {
                            strongSelf.showCustomView(customView: hudToPresent.customView, dismissAfter: hudToPresent.dismissAfter, userInteractionEnabled: hudToPresent.userInteractionEnabled, customLayout: hudToPresent.customLayout)
                            strongSelf.viewQueue.remove(at: 0)
                        }
                        completion?(finished)
                    }
            })
        }
    }

    public func dismissAllAlerts() {
        viewQueue = []
        dismissCurrentView()
    }
    
}
