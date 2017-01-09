//
//  MainViewController.swift
//  beblueapp
//
//  Created by Alessandro Nakamuta on 8/19/15.
//  Copyright (c) 2015 BeBlue. All rights reserved.
//

import UIKit
import Cartography

public class ExchangeViewController: UIViewController {

    private(set) var currentViewController: UIViewController? {
        didSet {

            if let currentViewController = currentViewController {

                currentViewController.willMove(toParentViewController: self)
                addChildViewController(currentViewController)
                currentViewController.didMove(toParentViewController: self)

                if let oldViewController = oldValue {
                    view.insertSubview(currentViewController.view, belowSubview: oldViewController.view)
                } else {
                    view.addSubview(currentViewController.view)
                }

                constrain(currentViewController.view, view, block: { childView, containerView in
                    childView.edges == containerView.edges
                })

                self.setNeedsStatusBarAppearanceUpdate()
            }

            if let oldViewController = oldValue {
                if let currentViewController = currentViewController {
                    currentViewController.view.transform = CGAffineTransform(scaleX: 0, y: 0)

                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                        currentViewController.view.transform = CGAffineTransform.identity
                        oldViewController.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
                        }, completion: { (completion) -> Void in
                            oldViewController.dismiss(animated: false, completion: nil)
                            oldViewController.willMove(toParentViewController: nil)
                            oldViewController.view.removeFromSuperview()
                            oldViewController.removeFromParentViewController()
                            UIApplication.shared.delegate?.window??.makeKeyAndVisible()
//                            (UIApplication.sharedApplication().delegate as! AppDelegate).window?.makeKeyAndVisible()
                    })
                } else {
                    oldViewController.dismiss(animated: false, completion: nil)
                    oldViewController.willMove(toParentViewController: nil)
                    oldViewController.view.removeFromSuperview()
                    oldViewController.removeFromParentViewController()
                    UIApplication.shared.delegate?.window??.makeKeyAndVisible()
//                    (UIApplication.sharedApplication().delegate as! AppDelegate).window?.makeKeyAndVisible()
                }
            }

        }
    }

    //MARK: Navigation Methods

//    func goToDashboardWithName(storyboardName: String) {
//        let viewController = UIStoryboard(name: storyboardName, bundle: NSBundle(forClass: self.dynamicType)).instantiateInitialViewController()!
//        goToViewController(viewController)
//    }

    public func goToViewController(toViewController: UIViewController?) {
        currentViewController = toViewController
    }
    
    public override var childViewControllerForStatusBarStyle: UIViewController?{
        return currentViewController
    }
    
    public override var childViewControllerForStatusBarHidden: UIViewController?{
        return currentViewController
    }
}
