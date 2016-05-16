//
//  BaseNavigationController.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 10/29/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import Cartography

public class JeraBaseNavigationController: UINavigationController {

    private weak var backgroundImageView: UIImageView?
    private var shadow: UIImage?
    private var backgroundImage: UIImage?
    private var isTranslucent: Bool?
    public var defaultStatusBarStyle = UIStatusBarStyle.Default{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        shadow = navigationBar.shadowImage
        backgroundImage = navigationBar.backgroundImageForBarMetrics(.Default)
        isTranslucent = navigationBar.translucent
    }

    //MARK: NavigationBar Helpers

    public func showNavigationBar(show: Bool) {
        if show {
            navigationBar.hidden = false
            navigationBar.shadowImage = shadow
        } else {
            navigationBar.hidden = true
            navigationBar.shadowImage = UIImage()
        }
    }

    public func showNavigationBarTransparent(transparent: Bool) {
        navigationBar.hidden = false

        if transparent {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar.translucent = true
        } else {
            navigationBar.shadowImage = shadow
            navigationBar.setBackgroundImage(backgroundImage, forBarMetrics: .Default)
            if let isTranslucent = isTranslucent {
                navigationBar.translucent = isTranslucent
            }
        }
    }

    public func setupBackgroundImage(image: UIImage) {
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
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return defaultStatusBarStyle
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

    public func removeListeners() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    //This method needs to be implemented by the subclass
    public func cancelAsynchronousTasks() {

    }

    //This method needs to be implemented by the subclass
    public func deallocOtherObjects() {

    }

}
