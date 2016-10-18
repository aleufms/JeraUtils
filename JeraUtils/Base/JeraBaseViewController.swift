//
//  BaseViewController.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 10/29/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import Cartography
import TZStackView
import WebKit

public enum BaseViewControllerMessagePosition {
    case Center(offset: CGPoint?)
    case Top(topOffset: CGFloat?)
    case CenterAndSides(centerOffset: CGPoint?, sideOffsets: CGFloat?)
//    case Custom(topOffset: CGFloat)
}

public class JeraBaseViewController: UIViewController {

    public lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .ScaleToFill
        return backgroundImageView
    }()

    public var showNavigation = true
    public var showTransparentNavigation = false
    public var viewLoaded = false
    private(set) var keyboardRect = CGRect.zero
    
    public var defaultStatusBarStyle = UIStatusBarStyle.Default{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }

//    var screenName: String? //For google Analytics


    @IBOutlet private var _scrollView: UIScrollView?
    public var scrollView: UIScrollView {
        get {
            if let _scrollView = _scrollView {
                return _scrollView
            } else {
                return createScrollView()
            }
        }
    }
    
    /** 
     Creates and inserts as subview a UIScrollView in the controller.
     - parameter edgeInsets: Position where the view is going to be created. By default the view is created with Insets (0,0,0,0)
     - retuns: UIScrollView
     */
    public func createScrollView(edgeInsets edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> UIScrollView {
        let scrollView = TPKeyboardAvoidingScrollView()
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.keyboardDismissMode = .Interactive
        scrollView.alwaysBounceVertical = true

        if view.subviews.contains(backgroundImageView) {
            self.view.insertSubview(scrollView, aboveSubview: backgroundImageView)
        } else {
            self.view.insertSubview(scrollView, atIndex: 0)
        }

        if let edgeInsets = edgeInsets {
            constrain(self.view, scrollView, block: { (view, scrollView) -> () in
                scrollView.top == view.top + edgeInsets.top
                scrollView.left == view.left + edgeInsets.left
                scrollView.bottom == view.bottom - edgeInsets.bottom
                scrollView.right == view.right - edgeInsets.right
            })
        }

        _scrollView = scrollView

        return scrollView
    }

    @IBOutlet private var _tableView: UITableView?
    public var tableView: UITableView {
        get {
            if let _tableView = _tableView {
                return _tableView
            } else {
                return createTableView()
            }
        }
    }
    /**
     Creates and inserts as subview a UICollectionView in the controller.
     - parameter edgeInsets: Position where the view is going to be created. By default the view is created with Insets (0,0,0,0)
     - returns: UICollectionView
     */
    public func createTableView(edgeInsets edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> UITableView {
        let tableView = TPKeyboardAvoidingTableView(frame: CGRect.zero, style: .Plain)

        if view.subviews.contains(backgroundImageView) {
            self.view.insertSubview(tableView, aboveSubview: backgroundImageView)
        } else {
            self.view.insertSubview(tableView, atIndex: 0)
        }
        
        if let edgeInsets = edgeInsets {
            constrain(self.view, tableView, block: { (view, tableView) -> () in
                tableView.top == view.top + edgeInsets.top
                tableView.left == view.left + edgeInsets.left
                tableView.bottom == view.bottom - edgeInsets.bottom
                tableView.right == view.right - edgeInsets.right
            })
        }

        tableView.keyboardDismissMode = .Interactive
        tableView.alwaysBounceVertical = true

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()

        _tableView = tableView

        return tableView
    }

    @IBOutlet var _collectionView: UICollectionView?
    public var collectionView: UICollectionView {
        get {
            if let _collectionView = _collectionView {
                return _collectionView
            } else {
                return createCollectionView()
            }
        }
    }
    /**
     Creates and inserts as subview a UICollectionView in the controller.
     - parameter edgeInsets: Position where the view is going to be created. By default the view is created with Insets (0,0,0,0)
     - returns: UICollectionView
     */
    public func createCollectionView(edgeInsets edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> UICollectionView {
        let collectionView = TPKeyboardAvoidingCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        if view.subviews.contains(backgroundImageView) {
            self.view.insertSubview(collectionView, aboveSubview: backgroundImageView)
        } else {
            self.view.insertSubview(collectionView, atIndex: 0)
        }

        if let edgeInsets = edgeInsets {
            constrain(self.view, collectionView, block: { (view, collectionView) -> () in
                collectionView.top == view.top + edgeInsets.top
                collectionView.left == view.left + edgeInsets.left
                collectionView.bottom == view.bottom - edgeInsets.bottom
                collectionView.right == view.right - edgeInsets.right
            })
        }

        collectionView.keyboardDismissMode = .Interactive
        collectionView.alwaysBounceVertical = true

        collectionView.backgroundColor = UIColor.clearColor()

        _collectionView = collectionView

        return collectionView
    }

    var _stackView: TZStackView?
    public var stackView: TZStackView {
        get {
            if let _stackView = _stackView {
                return _stackView
            } else {
                return createStackView()
            }
        }
    }
    /**
     Creates and inserts as subview a TZStackView in the controller.
     - parameter edgeInsets: Position where the view is going to be created. By default the view is created with Insets (0,0,0,0)
     - returns: TZStackView
     */
    public func createStackView(edgeInsets edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> TZStackView {
        let stackView = TZStackView()
        stackView.axis = .Vertical

//        if _scrollView == nil {
//            createScrollView()
//        }
        scrollView.addSubview(stackView)

        
        if let edgeInsets = edgeInsets {
            constrain(self.scrollView, stackView) { (scrollView, stackView) -> () in
                stackView.edges == inset(scrollView.edges, edgeInsets.top, edgeInsets.left, edgeInsets.bottom, edgeInsets.right)
                stackView.width == UIScreen.mainScreen().bounds.size.width - edgeInsets.left - edgeInsets.right
            }
        }

        _stackView = stackView

        return stackView
    }
//
//    @IBOutlet var _webView: JeraWebView?
//    var webView: JeraWebView{
//        get{
//            if let _webView = _webView{
//                return _webView
//            }else{
//                return createWebView()
//            }
//        }
//    }
//    func createWebView(edgeInsets edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> JeraWebView{
//        let webView = JeraWebView()
//        webView.backgroundColor = UIColor.clearColor()
//
//        if let backgroundImageView = self.backgroundImageView{
//            self.view.insertSubview(webView, aboveSubview: backgroundImageView)
//        }else{
//            self.view.insertSubview(webView, atIndex: 0)
//        }
//
//        constrain(self.view, webView, block: { (view, webView) -> () in
//            webView.top == view.top + edgeInsets.top
//            webView.left == view.left + edgeInsets.left
//            webView.bottom == view.bottom - edgeInsets.bottom
//            webView.right == view.right - edgeInsets.right
//        })
//
//        webView.backgroundColor = UIColor.clearColor()
//
//        _webView = webView
//
//        return webView
//    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        viewLoaded = true

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        self.applyLabels()
        self.applyFonts()
        self.applyLayout()

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: ReachabilityHelper.sharedReachability)
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if !showNavigation {
            showNavigationBar(false)
        } else if showTransparentNavigation {
            showNavigationBarTransparent(true)
        }

        // Google Analytics
//        if let screenName = screenName {
//            Helper.analyticsRegisterScreenName(screenName)
//        }
    }

    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if !showNavigation {
            showNavigationBar(true)
        } else if showTransparentNavigation {
            showNavigationBarTransparent(false)
        }
    }

    //MARK: Appliers
    public func applyLabels() {
    }

    public func applyFonts() {

    }

    public func applyLayout() {
//        view.backgroundColor = Helper.backgroundColor
    }

    //MARK: Background image
    public func setupBackgroundImage(image: UIImage? = nil) {
        backgroundImageView.image = image
        view.insertSubview(backgroundImageView, atIndex: 0)

        constrain(view, backgroundImageView) { (view, backgroundImageView) -> () in
            backgroundImageView.edges == view.edges
        }
    }

//    func setupBackgroundGradient(topColor topColor: UIColor, bottomColor: UIColor){
//        view.addBackgroundGradient(topColor: topColor, bottomColor: bottomColor)
//    }

    //MARK: Navbar Helpers

    private func showNavigationBar(show: Bool) {
        if let navigationController = self.navigationController as? JeraBaseNavigationController {
            navigationController.showNavigationBar(show)
        }
    }

    private func showNavigationBarTransparent(show: Bool) {
        if let navigationController = self.navigationController as? JeraBaseNavigationController {
            navigationController.showNavigationBarTransparent(show)
        }
    }

    //MARK: Appearence
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return defaultStatusBarStyle
    }

    //MARK: Keyboard
    public func listenKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JeraBaseViewController.keyboardWillShow), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JeraBaseViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }

    public func keyboardWillShow(sender: NSNotification) {
        if let keyboardRect = sender.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
            self.keyboardRect = keyboardRect
        }
    }

    public func keyboardWillHide(sender: NSNotification) {
        keyboardRect = CGRect.zero
    }

    //MARK: Dealloc
    deinit {
        removeListeners()
        cancelAsynchronousTasks()
        deallocOtherObjects()

        print("Dealloc: \(String(self.dynamicType))")
    }

    public func removeListeners() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    public func cancelAsynchronousTasks() {

    }

    public func deallocOtherObjects() {

    }
}

public extension UIViewController {
    //MARK: TitleView
    public func setupLogoTitleImage(image: UIImage, tintColor: UIColor? = nil) {
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.titleView?.tintColor = tintColor
    }
}

public extension UIViewController {
    //MARK: Close
    public func addCloseButton(image image: UIImage? = nil) {
        if let image = image{
            let closeIconBarButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(UIViewController.close))
            navigationItem.leftBarButtonItem = closeIconBarButton
        }else{
            if let closeIcon = UIImage.bundleImage(named: "ic_close"){
                let closeIconBarButton = UIBarButtonItem(image: closeIcon, style: .Plain, target: self, action: #selector(UIViewController.close))
                navigationItem.leftBarButtonItem = closeIconBarButton
            }else{
                let closeIconBarButton = UIBarButtonItem(title: "Fechar", style: .Plain, target: self, action: #selector(UIViewController.close))
                navigationItem.leftBarButtonItem = closeIconBarButton
            }
        }
    }

    /**
     Dismisses the Controller when opened as a modal, otherwise it pops it away.
     */
    public func close() {
        if isModal() {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }

    /**
     Returns whether the controller was opened as a Modal or not.
     - returns: Bool
     */
    public func isModal() -> Bool {
        if let _ = presentingViewController {
            return true
        }
        if presentingViewController?.presentedViewController == self {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if tabBarController?.presentingViewController?.isKindOfClass(UITabBarController.self) == true {
            return true
        }

        return false
    }
}

public extension TZStackView {
    public func removeAllArrangedSubviews() {
        for removeSubview in arrangedSubviews {
            removeArrangedSubview(removeSubview)
            removeSubview.removeFromSuperview()
        }
    }
}
