//
//  JeraPushNotificationHelper.swift
//  Ativoapp
//
//  Created by Adriano Wahl on 07/12/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import RxSwift

class JeraPushNotificationHelper {
    let disposeBag = DisposeBag()
    
    var deviceToken: String?
    static var sharedInstance = JeraPushNotificationHelper()
        
    func showNotification(notification: NSDictionary){
        #if DEBUG
            print("Push payload: \(notification)")
        #endif
        
        let apsInfo = notification["aps"] as! NSDictionary
        let message = apsInfo["alert"] as? String
        let notificationType = notification["type"] as? Int
        
        if let topViewController = Helper.topViewController(){
            if let message = message{
                AlertManager.sharedManager.alert(title: "Nova mensagem", message: message, options: ["OK"], hasCancel: notificationType != nil, preferredStyle: .Alert, presenterViewController: topViewController).subscribeNext({ [weak self] (option) -> Void in
                    if let strongSelf = self{
                        switch option{
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
    
    func handleNotification(notification: NSDictionary){
//        print("TODO handleNotification for \(notification)")
//        
//        if let mappedNotificationType = notification["type"] as? Int{
//            if let mainDrawerMenuViewController = MainDrawerMenuViewController.sharedInstance{
//                mainDrawerMenuViewController.goToNotificationType(NotificationType(rawValue: mappedNotificationType), refresh: true)
//            }
//        }
    }
    
    var tokenRegisterDisposeBag: DisposeBag!
    func registerDeviceToken(deviceTokenData: NSData){
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
    
    var pendentNotification: NSDictionary?
    func showPendentNotification(){
        if let pendentNotification = pendentNotification{
            showNotification(pendentNotification)
        }
    }
    
    class func deviceTokenDataToString(deviceToken: NSData) -> String{
        let deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString("<", withString: "")
            .stringByReplacingOccurrencesOfString(">", withString: "")
            .stringByReplacingOccurrencesOfString(" ", withString: "")
        
        return deviceTokenStr
    }
    
    class func registerForRemoteNotifications(){
        UIApplication.sharedApplication().registerForRemoteNotifications()
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
    }
    
    class func unregisterForRemoteNotifications(){
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
    }
}
