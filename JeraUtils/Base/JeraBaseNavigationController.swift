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
    public var defaultStatusBarStyle = UIStatusBarStyle.default{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        shadow = navigationBar.shadowImage
        backgroundImage = navigationBar.backgroundImage(for: .default)
        isTranslucent = navigationBar.isTranslucent
    }

    //MARK: NavigationBar Helpers

    public func showNavigationBar(show: Bool) {
        if show {
            navigationBar.isHidden = false
            navigationBar.shadowImage = shadow
        } else {
            navigationBar.isHidden = true
            navigationBar.shadowImage = UIImage()
        }
    }

    public func showNavigationBarTransparent(transparent: Bool) {
        navigationBar.isHidden = false

        if transparent {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.isTranslucent = true
        } else {
            navigationBar.shadowImage = shadow
            navigationBar.setBackgroundImage(backgroundImage, for: .default)
            if let isTranslucent = isTranslucent {
                navigationBar.isTranslucent = isTranslucent
            }
        }
    }

    public func setupBackgroundImage(image: UIImage) {
        self.backgroundImageView?.removeFromSuperview()
        self.backgroundImageView = nil

        let backgroundImageView = UIImageView(image: image)
        backgroundImageView.contentMode = .scaleToFill

        view.insertSubview(backgroundImageView, at: 0)

        constrain(view, backgroundImageView, block: { (view, backgroundImageView) -> () in
            backgroundImageView.edges == view.edges
        })

        self.backgroundImageView = backgroundImageView
    }

    //MARK: Appearence
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return defaultStatusBarStyle
    }

    //MARK: Dealloc
    deinit {
        self.removeListeners()
        self.cancelAsynchronousTasks()
        self.deallocOtherObjects()

        #if DEBUG
            print("Dealloc: \(NSStringFromClass(type(of: self)))")
        #endif
    }

    public func removeListeners() {
        NotificationCenter.default.removeObserver(self)
    }

    //This method needs to be implemented by the subclass
    public func cancelAsynchronousTasks() {

    }

    //This method needs to be implemented by the subclass
    public func deallocOtherObjects() {

    }

}
