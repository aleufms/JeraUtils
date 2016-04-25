//
//  HudViewController.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 9/16/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import Cartography

class HudViewController: JeraBaseViewController {

    let bottomInsetConstraintGroup = ConstraintGroup()
    
    class func centerLayout() -> (containerView: UIView, customView: UIView) -> () {
        return { (containerView, customView) -> () in
            constrain(containerView, customView, block: { (containerView, customView) -> () in
                customView.center == containerView.center
                customView.width <= containerView.width - 40
                customView.height <= containerView.height - 40
            })
        }
    }
    
    class func bottomLayout(bottomInset: CGFloat = 40) -> (containerView: UIView, customView: UIView) -> () {
        return { (containerView, customView) -> () in
            constrain(containerView, customView, block: { (containerView, customView) -> () in
                customView.centerX == containerView.centerX ~ 300
                customView.bottom == containerView.bottom - bottomInset ~ 300
                customView.top >= containerView.top + 40
                customView.width <= containerView.width - 40
            })
        }
    }
    
    var customViewLayout: (containerView: UIView, customView: UIView) -> () = HudViewController.centerLayout()
    
    lazy var visibleView: UIView = {
        let visibleView = UIView(frame: self.view.frame)
        self.view.addSubview(visibleView)
        constrain(self.view, visibleView, block: { (view, visibleView) -> () in
            visibleView.top == view.top
            visibleView.left == view.left
            visibleView.right == view.right
        })
        
        return visibleView
    }()
    
    var customView: UIView?{
        didSet{
            if let oldView = oldValue{
                oldView.removeFromSuperview()
            }
            if let customView = customView{
                visibleView.addSubview(customView)
                customViewLayout(containerView: visibleView, customView: customView)
            }
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constrain(view, visibleView, replace: bottomInsetConstraintGroup, block: { (view, visibleView) -> () in
            visibleView.bottom == view.bottom - keyboardRect.size.height
        })
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor(white: 0, alpha: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenKeyboard()
    }
    
    override func keyboardWillShow(sender: NSNotification) {
        super.keyboardWillShow(sender)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        super.keyboardWillHide(sender)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
