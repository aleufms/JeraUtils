//
//  JeraPushNotificationHelper.swift
//  Ativoapp
//
//  Created by Adriano Wahl on 07/12/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import RxSwift

public class JeraPushNotificationHelper {
    public static var sharedInstance = JeraPushNotificationHelper()
    
    private let disposeBag = DisposeBag()
    
    public private(set) var deviceToken: NSData?{
        didSet{
            if let deviceToken = deviceToken{
                deviceTokenSubject.onNext(deviceToken)
            }
        }
    }
    
    public let deviceTokenSubject = PublishSubject<NSData>()
    
    public let pushNotificationSubject = PublishSubject<[NSObject : AnyObject]>()
    
    /**
     Transform a deviceToken NSData to a String and allocs it to the deviceToken Variable
     
     - parameter deviceTokenData: The NSData for the Device Token to be alloced.
     */
    public func registerDeviceToken(deviceTokenData: NSData) {
        self.deviceToken = deviceTokenData
        print("APNS: \(JeraPushNotificationHelper.deviceTokenDataToString(deviceTokenData))")
    }
    
    public func receiveNotification(notification: [NSObject : AnyObject]){
        pushNotificationSubject.onNext(notification)
    }
    
    private var launchNotification: [NSObject : AnyObject]?
    public func registerLaunchNotification(launchOptions: [NSObject: AnyObject]?){
        if let launchNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject: AnyObject] {
            self.launchNotification = launchNotification
        }
    }
    
    public func processLaunchNotification() {
        if let launchNotification = launchNotification {
            pushNotificationSubject.onNext(launchNotification)
            self.launchNotification = nil
        }
    }
    
    /**
     Converts a Device Token as NSData to a String
     
     - parameter deviceToken: The NSData to be converted
     
     - returns: The Device Token as a String
     */
    public class func deviceTokenDataToString(deviceToken: NSData) -> String {
        let deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString("<", withString: "")
            .stringByReplacingOccurrencesOfString(">", withString: "")
            .stringByReplacingOccurrencesOfString(" ", withString: "")
        
        return deviceTokenStr
    }
    
    /**
     Ask for permisions and register the user for Remote Notifications with Sound, Alert and Badge.
     */
    public class func registerForRemoteNotifications() {
        if UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings:"){
            //iOS > 8
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
        }else{
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }
    
    public class func unregisterForRemoteNotifications() {
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
    }
    
    public class func setNotificationBadge(count: Int) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = count
    }
}
