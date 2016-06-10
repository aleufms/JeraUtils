//
//  Helper.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 10/29/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import Foundation
import UIKit
import Cartography

public class Helper {
    class func storyBoardWithName(name: String, storyboardId: String? = nil) -> UIViewController {
        if let storyboardId = storyboardId {
            return UIStoryboard(name: name, bundle: nil).instantiateViewControllerWithIdentifier(storyboardId)
        } else {
            return UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        }
    }
}

//Project variables
public extension Helper {
    public class func projectDomain() -> String {
        if let displayName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String {
            return displayName
        }

        return "app"
    }
}

//MARK: App Version
public extension Helper {
    public class func getShortVersion() -> String {
        if let shortVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return shortVersion
        }

        return "version"
    }
}

//MARK: NSData (JSON)
public extension Helper {
    public class func convertJSONToDictionary(data data: NSData) -> [String:AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

    public class func convertDictionaryToJSON(dict dict: [String: AnyObject]) -> NSData? {
        do {
            return try NSJSONSerialization.dataWithJSONObject(dict, options: [])
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

    public class func convertJSONToArray(data data: NSData) -> [AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [AnyObject]
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

    public class func convertArrayToJSON(array array: [AnyObject]) -> NSData? {
        do {
            return try NSJSONSerialization.dataWithJSONObject(array, options: [])
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}

//MARK: Share
public extension Helper {
    public class func shareAction(text text: String? = nil, url: NSURL? = nil, topViewController: UIViewController) {
        var activityItems = [AnyObject]()
        if let text = text {
            activityItems.append(text)
        }
        if let url = url {
            activityItems.append(url)
        }

        if activityItems.count > 0 {
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

            topViewController.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
}

//MARK: Associated Objects
//https://medium.com/@ttikitu/swift-extensions-can-add-stored-properties-92db66bce6cd#.90czr5lvc
//extension Miller {
//    var cat: Cat { // cat is *effectively* a stored property
//        get {
//            return associatedObject(self, key: &catKey)
//                { return Cat() } // Set the initial value of the var
//        }
//        set { associateObject(self, key: &catKey, value: newValue) }
//    }
//}

////MARK: StackView
//extension Helper{
//
//}

public enum SeparatorViewPosition {
    case Top
    case Bottom
}

public extension String {
    var URLEscapedString: String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
    }
}

public extension Helper {
    /**
     Create a separator view

     - parameter color:     Color of separator. Default: UIColor(white: 0, alpha: 0.12)
     - parameter height:     Height contraint.
     - parameter insets:     Space from borders.

     - returns: The separator view.
     */
    public class func separatorView(color color: UIColor = UIColor(white: 0, alpha: 0.12), height: CGFloat = 1, insets: UIEdgeInsets = UIEdgeInsetsZero) -> UIView {
        let separatorView = UIView()

        separatorView.backgroundColor = color


        constrain(separatorView) { (separatorView) -> () in
            separatorView.height == height / UIScreen.mainScreen().nativeScale
        }

        if insets != UIEdgeInsetsZero {
            return separatorView.containerViewWithInsets(insets)
        }

        return separatorView
    }

    /**
     Create a view with constraint height.

     - parameter height:     Height contraint.

     - returns: The spacing view.
     */
    public class func spacingView(height height: CGFloat) -> UIView {
        let spacingView = UIView()
        constrain(spacingView) { (spacingView) -> () in
            spacingView.height == height
        }

        return spacingView
    }
}

public extension String {
    public func isValidEmail() -> Bool{
        //        let stricterFilter = true
        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        //        let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = stricterFilterString
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluateWithObject(self)
    }
        
//    var length : Int {
//        return self.characters.count
//    }
    
    public func digitsOnly() -> String{
        let stringArray = self.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        
        return newString
    }
}

public extension UIView {
    func addSeparatorView(color color: UIColor = UIColor(white: 0, alpha: 0.12), height: CGFloat = 1, insets: UIEdgeInsets = UIEdgeInsetsZero, position: SeparatorViewPosition = .Bottom) -> UIView {
        let separatorView = Helper.separatorView(color: color, height: height)
        let containerSeparatorView = separatorView.containerViewWithInsets(insets)

        addSubview(containerSeparatorView)
        constrain(self, containerSeparatorView, block: { (view, containerSeparatorView) -> () in
            containerSeparatorView.left == view.left
            containerSeparatorView.right == view.right

            switch position {
            case .Top:
                containerSeparatorView.top == view.top
            case .Bottom:
                containerSeparatorView.bottom == view.bottom
            }
        })

        return separatorView
    }

    /**
     Put the view inside another view with insets.

     - parameter insets:     Insets from edges.

     - returns: The container view.
     */
    func containerViewWithInsets(insets: UIEdgeInsets = UIEdgeInsetsZero) -> UIView {
        let containerView = UIView()
        containerView.addSubview(self)
        constrain(containerView, self) { (containerView, view) -> () in
            view.top == containerView.top + insets.top
            view.left == containerView.left + insets.left
            view.right == containerView.right - insets.right
            view.bottom == containerView.bottom - insets.bottom
        }

        return containerView
    }
}

//extension UIWindow {
//
//    func visibleViewController() -> UIViewController? {
//        if let rootViewController: UIViewController = self.rootViewController {
//            return UIWindow.getVisibleViewControllerFrom(rootViewController)
//        }
//        return nil
//    }
//
//    class func getVisibleViewControllerFrom(vc: UIViewController) -> UIViewController? {
//
//        if vc.isKindOfClass(UINavigationController.self) {
//
//            let navigationController = vc as? UINavigationController
//            return UIWindow.getVisibleViewControllerFrom(navigationController.visibleViewController)
//
//        } else if vc.isKindOfClass(UITabBarController.self) {
//
//            let tabBarController = vc as? UITabBarController
//            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController)
//
//        } else {
//
//            if let presentedViewController = vc.presentedViewController {
//
//                return UIWindow.getVisibleViewControllerFrom(presentedViewController.presentedViewController!)
//
//            } else {
//
//                return vc;
//            }
//        }
//    }
//}

public extension Helper {
    class func topViewController(base base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

//public extension Helper {
//    class func topViewController(rootViewController: UIViewController? = nil) -> UIViewController? {
//        if let rootViewController = rootViewController {
//            if let navigationController = rootViewController as? UINavigationController {
//                return navigationController.visibleViewController
//            } else if let tabBarController = rootViewController as? UITabBarController {
//                return tabBarController.selectedViewController
//            } else {
//                if let presentedViewController = rootViewController.presentedViewController {
//                    return presentedViewController.presentedViewController!
//                } else {
//                    return rootViewController
//                }
//            }
//        } else {
//            if let keyWindowRootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
//                return topViewController(keyWindowRootViewController)
//            } else {
//                return nil
//            }
//        }
//    }
//}

public extension UIImage {
    class func bundleImage(named named: String) -> UIImage?{
        return UIImage(named: named, inBundle: NSBundle(identifier: "org.cocoapods.JeraUtils"), compatibleWithTraitCollection: nil)
    }
    
    class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func resizeImage(image image: UIImage, maxSize: CGSize) -> UIImage {
        let resizedProfilePhoto: UIImage!
        if image.size.height > maxSize.height || image.size.width > maxSize.width{
            //Resize photo
            let rect = CGRect(origin: CGPointZero, size: maxSize)
            UIGraphicsBeginImageContext( rect.size );
            image.drawInRect(rect)
            resizedProfilePhoto = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }else{
            resizedProfilePhoto = image
        }
        return resizedProfilePhoto
    }
}

//- (UIViewController *)topViewController{
//    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//    }
//
//    - (UIViewController *)topViewController:(UIViewController *)rootViewController
//{
//    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *navigationController = (UINavigationController *)rootViewController;
//        return [self topViewController:[navigationController.viewControllers lastObject]];
//    }
//    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabController = (UITabBarController *)rootViewController;
//        return [self topViewController:tabController.selectedViewController];
//    }
//    if (rootViewController.presentedViewController) {
//        return [self topViewController:rootViewController];
//    }
//    return rootViewController;
//}

public extension Helper {
    public class func toCurrency(price: NSNumber, localeIdentifier: String = "pt_BR") -> String? {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: localeIdentifier)
        
        return formatter.stringFromNumber(price)
    }
}

public extension Helper {
    public class func callPhone(phone: String?) -> NSError?{
        if let phone = phone, phoneURL = NSURL(string: "telprompt://\(phone.digitsOnly())"){
            if UIApplication.sharedApplication().canOpenURL(phoneURL){
                UIApplication.sharedApplication().openURL(phoneURL)
                return nil
            }else{
                return AlertManager.createErrorForAlert("", localizedDescription: "Aparelho não pode fazer ligações", alertRetry: false)
            }
        }
        return AlertManager.createErrorForAlert("", localizedDescription: "Número inválido", alertRetry: false)
    }
}