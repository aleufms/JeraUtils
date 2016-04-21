//
//  BaseSegmentedTabBarViewController.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 11/9/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import Cartography
import HMSegmentedControl

protocol SegmentedViewControllerDelegate: class {
    func indexChanged(selectedIndex: Int)
}

class SegmentedViewController: JeraBaseViewController {

    weak var delegate: SegmentedViewControllerDelegate?

    // TODO
//    private var _selectedIndex: Int
    var selectedIndex: Int {
        set {
            contentTabBarController.selectedIndex = newValue
            segmentedControl.selectedSegmentIndex = newValue
            if let delegate = delegate {
                delegate.indexChanged(newValue)
            }
        }
        get {
            return contentTabBarController.selectedIndex
        }
    }

    private var edgeInsetsConstraintGroup = ConstraintGroup()

    var tabBarContainerViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            constrain(view, tabBarContainerView, segmentedControl, replace: edgeInsetsConstraintGroup) { (view, tabBarContainerView, segmentedControl) -> () in
                tabBarContainerView.top == segmentedControl.bottom + tabBarContainerViewEdgeInsets.top
                tabBarContainerView.left == view.left + tabBarContainerViewEdgeInsets.left
                tabBarContainerView.right == view.right - tabBarContainerViewEdgeInsets.right
                tabBarContainerView.bottom == view.bottom - tabBarContainerViewEdgeInsets.bottom
            }
        }
    }

    var tabBarContainerView = UIView()

    lazy var contentTabBarController: UITabBarController = {
        let contentTabBarController = UITabBarController()
        contentTabBarController.tabBar.hidden = true
        return contentTabBarController
    }()

    var sections: [(title: String, viewController: UIViewController)]? {
        didSet {
            if let sections = sections{
                let titles = sections.map { (section) -> String in
                    return section.title
                }
                segmentedControl.sectionTitles = titles
                
                let controllers = sections.map { (section) -> UIViewController in
                    return section.viewController
                }
                contentTabBarController.viewControllers = controllers
                
                segmentedControl.setSelectedSegmentIndex(0, animated: false)
            }else{
                segmentedControl.sectionTitles = nil
                contentTabBarController.viewControllers = nil
            }
        }
    }

    lazy var segmentedControl: HMSegmentedControl = {
        let segmentedControl = HMSegmentedControl()

        self.configureSegmentedControl(segmentedControl)

        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        view.addSubview(segmentedControl)
        constrain(view, segmentedControl) { (view, segmentedControl) -> () in
            segmentedControl.top == view.top
            segmentedControl.left == view.left
            segmentedControl.right == view.right
            segmentedControl.height == 44
        }

        segmentedControl.indexChangeBlock = { [weak self] (selectedIndex) -> Void in
            if let strongSelf = self {
                strongSelf.selectedIndex = selectedIndex
            }
        }

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)

        view.addSubview(tabBarContainerView)
        tabBarContainerViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        contentTabBarController.willMoveToParentViewController(self)
        self.addChildViewController(contentTabBarController)
        contentTabBarController.didMoveToParentViewController(self)

        tabBarContainerView.addSubview(contentTabBarController.view)
        constrain(tabBarContainerView, contentTabBarController.view) { (tabBarContainerView, contentTabBarControllerView) -> () in
            contentTabBarControllerView.edges == tabBarContainerView.edges
        }

    }

    func configureSegmentedControl(segmentedControl: HMSegmentedControl) {
        //the subclasses have to custom this
    }
}
