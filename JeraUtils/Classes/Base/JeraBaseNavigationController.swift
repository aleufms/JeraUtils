//
//  BaseNavigationController.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 10/29/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import Cartography

class JeraBaseNavigationController: UINavigationController {

    private weak var backgroundImageView: UIImageView?
    private var shadow: UIImage?
    private var backgroundImage: UIImage?
    private var isTranslucent: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        shadow = navigationBar.shadowImage
        backgroundImage = navigationBar.backgroundImageForBarMetrics(.Default)
        isTranslucent = navigationBar.translucent

        navigationBar.titleTextAttributes =
            [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 17)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    //MARK: NavigationBar Helpers

    func showNavigationBar(show: Bool) {
        if show {
            navigationBar.hidden = false
            navigationBar.shadowImage = shadow
        }else {
            navigationBar.hidden = true
            navigationBar.shadowImage = UIImage()
        }
    }

    func showNavigationBarTransparent(transparent: Bool) {
        navigationBar.hidden = false

        if transparent {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar.translucent = true
        }else {
            navigationBar.shadowImage = shadow
            navigationBar.setBackgroundImage(backgroundImage, forBarMetrics: .Default)
            if let isTranslucent = isTranslucent {
                navigationBar.translucent = isTranslucent
            }
        }
    }

    func setupBackgroundImage(image: UIImage) {
        self.backgroundImageView?.removeFromSuperview()
        self.backgroundImageView = nil

        let backgroundImageView = UIImageView(image: image)
        backgroundImageView.contentMode = .ScaleToFill

        view.insertSubview(backgroundImageView, atIndex: 0)

        constrain(view, backgroundImageView, block: { (view, backgroundImageView) -> () in
            backgroundImageView.edges == view.edges
        })

        self.backgroundImageView = backgroundImageView
    }

    //MARK: Appearence
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    //MARK: Dealloc
    deinit {
        self.removeListeners()
        self.cancelAsynchronousTasks()
        self.deallocOtherObjects()

        #if DEBUG
            print("Dealloc: \(NSStringFromClass(self.dynamicType))")
        #endif
    }

    func removeListeners() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func cancelAsynchronousTasks() {

    }

    func deallocOtherObjects() {

    }

}
