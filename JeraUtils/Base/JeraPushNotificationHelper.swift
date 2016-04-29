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
    public let disposeBag = DisposeBag()

    public var deviceToken: String?
    public static var sharedInstance = JeraPushNotificationHelper()

    public func showNotification(notification: NSDictionary) {
        #if DEBUG
            print("Push payload: \(notification)")
        #endif

        let apsInfo = notification["aps"] as! NSDictionary
        
        var message: String?
        var title: String?
        if let alert = apsInfo["alert"] as? String{
            message = alert
        }else if let alertDictionary = apsInfo["alert"] as? NSDictionary{
            title = alertDictionary["title"] as? String
            message = alertDictionary["body"] as? String
        }
        
        let notificationType = notification["type"] as? Int

        if let topViewController = Helper.topViewController() {
            if let message = message {
                AlertManager.sharedManager.alert(title: title ?? "Nova mensagem", message: message, options: ["OK"], hasCancel: notificationType != nil, preferredStyle: .Alert, presenterViewController: topViewController).subscribeNext({ [weak self] (option) -> Void in
                    if let strongSelf = self {
                        switch option {
                        case .Button:
                            strongSelf.handleNotification(notification)
                        default:
                            break
                        }
                    }
                }).addDisposableTo(disposeBag)
            }
        }

    }

    public func handleNotification(notification: NSDictionary) {
//        print("TODO handleNotification for \(notification)")
//
//        if let mappedNotificationType = notification["type"] as? Int{
//            if let mainDrawerMenuViewController = MainDrawerMenuViewController.sharedInstance{
//                mainDrawerMenuViewController.goToNotificationType(NotificationType(rawValue: mappedNotificationType), refresh: true)
//            }
//        }
    }

    public var tokenRegisterDisposeBag: DisposeBag!
    public func registerDeviceToken(deviceTokenData: NSData) {
        let deviceToken = JeraPushNotificationHelper.deviceTokenDataToString(deviceTokenData)
        print("APNS \(deviceToken)")

        //TODO: fazer template com api
//        tokenRegisterDisposeBag = DisposeBag()
//        GlamboxAPI.registerDevice(deviceToken).subscribe { (event) -> Void in
//            switch event{
//            case .Next:
//                print("SUCCESS")
//                break
//            case .Error(let error):
//                print("Failed to register APNS token: \(error)")
//            default:
//                break
//            }
//        }.addDisposableTo(tokenRegisterDisposeBag)

        self.deviceToken = deviceToken
    }

    public var pendentNotification: NSDictionary?
    public func showPendentNotification() {
        if let pendentNotification = pendentNotification {
            showNotification(pendentNotification)
        }
    }

    public class func deviceTokenDataToString(deviceToken: NSData) -> String {
        let deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString("<", withString: "")
            .stringByReplacingOccurrencesOfString(">", withString: "")
            .stringByReplacingOccurrencesOfString(" ", withString: "")

        return deviceTokenStr
    }

    public class func registerForRemoteNotifications() {
        UIApplication.sharedApplication().registerForRemoteNotifications()
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
    }

    public class func unregisterForRemoteNotifications() {
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
    }
}
