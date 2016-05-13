//
//  DrawerController.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 10/29/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import MMDrawerController

public protocol DrawerPage {
    var id: String { get }
    var viewController: UIViewController { get }
}

public class DrawerMenuViewController: MMDrawerController {

    public var currentPage: DrawerPage?
    
    deinit {
        #if DEBUG
            print("Dealloc: \(String(self.dynamicType))")
        #endif
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        openDrawerGestureModeMask = MMOpenDrawerGestureMode.All
        closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All

        var panGR: UIPanGestureRecognizer?
        if let arrayGR = view.gestureRecognizers {
            for gr in arrayGR {
                if gr.isKindOfClass(UIPanGestureRecognizer) {
                    panGR = gr as? UIPanGestureRecognizer
                    break
                }
            }
            panGR?.addTarget(self, action: #selector(DrawerMenuViewController.closeKeyboard))
        }
    }

    public func closeKeyboard() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }

    //MARK: Go to
    public func goToBaseDrawerPage(page: DrawerPage, refresh: Bool = false, closeDrawer: Bool = true) {
        if refresh || currentPage?.id != page.id {
            goToViewController(page.viewController)
            currentPage = page
        }

        if closeDrawer {
            closeDrawerAnimated(true, completion: nil)
        }
    }

    private func goToViewController(viewController: UIViewController) {

        if let centerViewController = centerViewController {
            centerViewController.dismissViewControllerAnimated(true, completion: nil)
        }

        centerViewController = viewController

        closeDrawerAnimated(true, completion: nil)
    }

}
