//
//  MainViewController.swift
//  beblueapp
//
//  Created by Alessandro Nakamuta on 8/19/15.
//  Copyright (c) 2015 BeBlue. All rights reserved.
//

import UIKit
import Cartography

class ExchangeViewController: UIViewController {

    private(set) var currentViewController: UIViewController? {
        didSet {

            if let currentViewController = currentViewController {

                currentViewController.willMoveToParentViewController(self)
                addChildViewController(currentViewController)
                currentViewController.didMoveToParentViewController(self)

                if let oldViewController = oldValue {
                    view.insertSubview(currentViewController.view, belowSubview: oldViewController.view)
                }else {
                    view.addSubview(currentViewController.view)
                }

                constrain(currentViewController.view, view, block: { childView, containerView in
                    childView.edges == containerView.edges
                })

                self.setNeedsStatusBarAppearanceUpdate()
            }

            if let oldViewController = oldValue {
                if let currentViewController = currentViewController {
                    currentViewController.view.transform = CGAffineTransformMakeScale(0, 0)

                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                        currentViewController.view.transform = CGAffineTransformIdentity
                        oldViewController.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height)
                        }, completion: { (completion) -> Void in
                            oldViewController.dismissViewControllerAnimated(false, completion: nil)
                            oldViewController.willMoveToParentViewController(nil)
                            oldViewController.view.removeFromSuperview()
                            oldViewController.removeFromParentViewController()
                            UIApplication.sharedApplication().delegate?.window??.makeKeyAndVisible()
//                            (UIApplication.sharedApplication().delegate as! AppDelegate).window?.makeKeyAndVisible()
                    })
                }else {
                    oldViewController.dismissViewControllerAnimated(false, completion: nil)
                    oldViewController.willMoveToParentViewController(nil)
                    oldViewController.view.removeFromSuperview()
                    oldViewController.removeFromParentViewController()
//                    (UIApplication.sharedApplication().delegate as! AppDelegate).window?.makeKeyAndVisible()
                    UIApplication.sharedApplication().delegate?.window??.makeKeyAndVisible()
                }
            }

        }
    }

    //MARK: Navigation Methods

//    func goToDashboardWithName(storyboardName: String) {
//        let viewController = UIStoryboard(name: storyboardName, bundle: NSBundle(forClass: self.dynamicType)).instantiateInitialViewController()!
//        goToViewController(viewController)
//    }

    func goToViewController(toViewController: UIViewController?) {
        currentViewController = toViewController
    }

    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return currentViewController
    }

    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return currentViewController
    }
}
