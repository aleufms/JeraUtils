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
import CoreTelephony

public class Helper {
    class func storyBoardWithName(name: String, storyboardId: String? = nil) -> UIViewController {
        if let storyboardId = storyboardId {
            return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: storyboardId)
        } else {
            return UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        }
    }
}

//Project variables
public extension Helper {
    public class func projectDomain() -> String {
        if let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return displayName
        }

        return "app"
    }
}

//MARK: App Version
public extension Helper {
    public class func getShortVersion() -> String {
        if let shortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return shortVersion
        }

        return "version"
    }
}

//MARK: NSData (JSON)
public extension Helper {
    public class func convertJSONToDictionary(data data: NSData) -> [String:AnyObject]? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

    public class func convertDictionaryToJSON(dict dict: [String: AnyObject]) -> NSData? {
        do {
            return try JSONSerialization.data(withJSONObject: dict, options: []) as NSData?
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

    public class func convertJSONToArray(data data: NSData) -> [AnyObject]? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: []) as? [AnyObject]
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

    public class func convertArrayToJSON(array array: [AnyObject]) -> NSData? {
        do {
            return try JSONSerialization.data(withJSONObject: array, options: []) as NSData?
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
            activityItems.append(text as AnyObject)
        }
        if let url = url {
            activityItems.append(url)
        }

        if activityItems.count > 0 {
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

            topViewController.present(activityViewController, animated: true, completion: nil)
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
    case Left
    case Right
}

public extension String {
    var URLEscapedString: String? {
        return String(describing: addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed))
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
    public class func separatorView(color color: UIColor = UIColor(white: 0, alpha: 0.12), height: CGFloat = 1, insets: UIEdgeInsets = UIEdgeInsets.zero) -> UIView {
        let separatorView = UIView()

        separatorView.backgroundColor = color


        constrain(separatorView) { (separatorView) -> () in
            separatorView.height == (height / UIScreen.main.nativeScale)
        }

        if insets != UIEdgeInsets.zero {
            return separatorView.containerViewWithInsets(insets: insets)
        }

        return separatorView
    }
    
    /**
     Create a separator view
     
     - parameter color:     Color of separator. Default: UIColor(white: 0, alpha: 0.12)
     - parameter height:     Height contraint.
     - parameter insets:     Space from borders.
     
     - returns: The separator view.
     */
    public class func separatorView(color color: UIColor = UIColor(white: 0, alpha: 0.12), width: CGFloat = 1, insets: UIEdgeInsets = UIEdgeInsets.zero) -> UIView {
        let separatorView = UIView()
        
        separatorView.backgroundColor = color
        
        
        constrain(separatorView) { (separatorView) -> () in
            separatorView.width == (width / UIScreen.main.nativeScale)
        }
        
        if insets != UIEdgeInsets.zero {
            return separatorView.containerViewWithInsets(insets: insets)
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
        
        return emailTest.evaluate(with: self)
    }
        
//    var length : Int {
//        return self.characters.count
//    }
    
    public func digitsOnly() -> String{
        let stringArray = self.components(
            separatedBy: NSCharacterSet.decimalDigits.inverted)
        let newString = stringArray.joined(separator: "")
        
        return newString
    }
}

public extension UIView {
    @discardableResult func addSeparatorView(color color: UIColor = UIColor(white: 0, alpha: 0.12), size: CGFloat = 1, insets: UIEdgeInsets = UIEdgeInsets.zero, position: SeparatorViewPosition = .Bottom) -> UIView {
        let separatorView: UIView
        switch position{
        case .Top, .Bottom:
            separatorView = Helper.separatorView(color: color, height: size)
        case .Right, .Left:
            separatorView = Helper.separatorView(color: color, width: size)
        }
        
        let containerSeparatorView = separatorView.containerViewWithInsets(insets: insets)
        addSubview(containerSeparatorView)
        constrain(self, containerSeparatorView, block: { (view, containerSeparatorView) -> () in
            switch position {
            case .Top:
                containerSeparatorView.left == view.left
                containerSeparatorView.right == view.right
                containerSeparatorView.top == view.top
            case .Bottom:
                containerSeparatorView.left == view.left
                containerSeparatorView.right == view.right
                containerSeparatorView.bottom == view.bottom
            case .Right:
                containerSeparatorView.top == view.top
                containerSeparatorView.bottom == view.bottom
                containerSeparatorView.right == view.right
            case .Left:
                containerSeparatorView.top == view.top
                containerSeparatorView.bottom == view.bottom
                containerSeparatorView.left == view.left
            }
        })

        return separatorView
    }

    /**
     Put the view inside another view with insets.

     - parameter insets:     Insets from edges.

     - returns: The container view.
     */
    func containerViewWithInsets(insets: UIEdgeInsets = UIEdgeInsets.zero) -> UIView {
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
    class func topViewController(base base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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

extension UIButton {
    func setTitle(_ title: String?, for state: UIControlState, animated: Bool){
        guard !animated else {
            setTitle(title, for: state)
            return
        }
        
        UIView.performWithoutAnimation {
            setTitle(title, for: state)
            
            layoutIfNeeded()
        }
    }
    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState, animated: Bool){
        guard !animated else {
            setAttributedTitle(title, for: state)
            return
        }
        
        UIView.performWithoutAnimation {
            setAttributedTitle(title, for: state)
            
            layoutIfNeeded()
        }
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
        return UIImage(named: named, in: Bundle(identifier: "org.cocoapods.JeraUtils"), compatibleWith: nil)
    }
    
    class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func resizeImage(image image: UIImage, maxSize: CGSize) -> UIImage {
        let resizedProfilePhoto: UIImage!
        if image.size.height > maxSize.height || image.size.width > maxSize.width{
            //Resize photo
            let rect = CGRect(origin: CGPoint.zero, size: maxSize)
            UIGraphicsBeginImageContext( rect.size );
            image.draw(in: rect)
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale(localeIdentifier: localeIdentifier) as Locale!
        
        return formatter.string(from: price)
    }
}

public extension Helper {
    public class func callPhone(phone: String?) -> NSError?{
        if let phone = phone, let phoneURL = NSURL(string: "telprompt://\(phone.digitsOnly())"){
            if UIApplication.shared.canOpenURL(phoneURL as URL){
                let netInfo = CTTelephonyNetworkInfo()
                if let carrier = netInfo.subscriberCellularProvider
                    , let mnc = carrier.mobileNetworkCode, mnc.characters.count > 0{
                    UIApplication.shared.openURL(phoneURL as URL)
                    return nil
                }
            }
            
            return AlertManager.createErrorForAlert(domain: "", localizedDescription: "Aparelho não pode fazer ligações. O telefone é: \(phone)", alertRetry: false)
            
        }
        return AlertManager.createErrorForAlert(domain: "", localizedDescription: "Número inválido", alertRetry: false)
    }
}

public extension String {
    public func translateSupAndSubString(font: UIFont = UIFont.systemFont(ofSize: 14), color: UIColor = UIColor.black) -> NSMutableAttributedString?{
        let fontSuper = font.withSize(font.pointSize*2/3)
        
        let attString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])
        
        for supIndex in indexesFor(regex: "<sup\\b[^>]*>(.*?)</sup>"){
            attString.setAttributes([NSFontAttributeName:fontSuper, NSBaselineOffsetAttributeName:5], range: supIndex)
        }
        
        for subIndex in indexesFor(regex: "<sub\\b[^>]*>(.*?)</sub>"){
            attString.setAttributes([NSFontAttributeName:fontSuper, NSBaselineOffsetAttributeName:-5], range: subIndex)
        }
        
        attString.removeOcurrencesOf(string: "<sub>")
        attString.removeOcurrencesOf(string: "</sub>")
        attString.removeOcurrencesOf(string: "<sup>")
        attString.removeOcurrencesOf(string: "</sup>")
        
        
        return attString
    }
    
    public func indexesFor(regex: String) -> [NSRange] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: self.characters.count))
            return results.map { $0.range }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
//    public func htmlAttributtedString(font: UIFont = UIFont.systemFont(ofSize: 14), color: UIColor = UIColor.black) -> NSMutableAttributedString?{
//        do {
//            let attributedString = try NSMutableAttributedString(data: data(using: String.Encoding.unicode,
//                                                                            allowLossyConversion: true)!,
//                                                                 options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType],
//                                                                 documentAttributes: nil)
//            
//            attributedString.addAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: color], range: NSRange(location: 0, length: attributedString.length))
//            return attributedString
//        } catch {
//            print(error)
//            return nil
//        }
//    }
}

public extension NSMutableAttributedString{
    public func removeOcurrencesOf(string substring: String){
        while string.contains(substring) {
            
            var range = (string as NSString).range(of: substring)
            replaceCharacters(in: range, with: "")
        }
    }
}
