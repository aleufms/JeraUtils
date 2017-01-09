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
            print("Dealloc: \(String(type(of: self)))")
        #endif
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        openDrawerGestureModeMask = MMOpenDrawerGestureMode.all
        closeDrawerGestureModeMask = MMCloseDrawerGestureMode.all

        var panGR: UIPanGestureRecognizer?
        if let arrayGR = view.gestureRecognizers {
            for gr in arrayGR {
                if gr is UIPanGestureRecognizer {
                    panGR = gr as? UIPanGestureRecognizer
                    break
                }
            }
            panGR?.addTarget(self, action: #selector(DrawerMenuViewController.closeKeyboard))
        }
    }

    public func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    //MARK: Go to
    public func goToBaseDrawerPage(page: DrawerPage, refresh: Bool = false, closeDrawer _closeDrawer: Bool = true) {
        if refresh || currentPage?.id != page.id {
            goToViewController(viewController: page.viewController)
            currentPage = page
        }

        if _closeDrawer {
            closeDrawer(animated: true, completion: nil)
        }
    }

    private func goToViewController(viewController: UIViewController) {

        if let centerViewController = centerViewController {
            centerViewController.dismiss(animated: true, completion: nil)
        }

        centerViewController = viewController

        closeDrawer(animated: true, completion: nil)
    }

}
