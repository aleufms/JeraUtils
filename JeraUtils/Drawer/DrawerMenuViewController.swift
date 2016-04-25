//
//  DrawerController.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 10/29/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import MMDrawerController

protocol DrawerPage {
    var id: String { get }
    var viewController: UIViewController { get }
}

class DrawerMenuViewController: MMDrawerController {

    var currentPage: DrawerPage?

    override func viewDidLoad() {
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

    func closeKeyboard() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }

    //MARK: Go to
    func goToBaseDrawerPage(page: DrawerPage, refresh: Bool = false, closeDrawer: Bool = true) {
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
