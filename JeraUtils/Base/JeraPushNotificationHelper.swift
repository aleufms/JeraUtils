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
    
    public let pushNotificationSubject = PublishSubject<NSDictionary>()
    
    /**
     Transform a deviceToken NSData to a String and allocs it to the deviceToken Variable
     
     - parameter deviceTokenData: The NSData for the Device Token to be alloced.
     */
    public func registerDeviceToken(deviceTokenData: NSData) {
        self.deviceToken = deviceTokenData
        print("APNS: \(JeraPushNotificationHelper.deviceTokenDataToString(deviceToken: deviceTokenData))")
    }
    
    public func receiveNotification(notification: NSDictionary){
        pushNotificationSubject.onNext(notification)
    }
    
    private var launchNotification: NSDictionary?
    public func registerLaunchNotification(launchOptions: [UIApplicationLaunchOptionsKey : Any]?){
        if let launchNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
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
        
        let deviceTokenStr = deviceToken.description.replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        return deviceTokenStr
    }
    
    /**
     Ask for permisions and register the user for Remote Notifications with Sound, Alert and Badge.
     */
    public class func registerForRemoteNotifications() {
        if UIApplication.shared.responds(to: "registerUserNotificationSettings:"){
            //iOS > 8
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        }else{
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    public class func unregisterForRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    public class func setNotificationBadge(count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = count
    }
}
