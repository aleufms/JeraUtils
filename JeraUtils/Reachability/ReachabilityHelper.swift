//
//  ReachabilityHelper.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 9/1/15.
//  Copyright (c) 2015 Jera. All rights reserved.
//

import ReachabilitySwift
import RxSwift

public class ReachabilityHelper {
    
        /// Tries to start reachability for internect connection and prints if unable.
    public static var sharedReachability: Reachability? = {
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            return reachability
        } catch {
            print("Unable to create Reachability")
            return nil
        }
    }()

    public class func startReachability() {
        do {
            try sharedReachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    /**
     Observes any changes in the connection state.
     
     - returns: Observable Reachability state.
     */
    public class func reachabilityChangedObservable() -> Observable<Reachability> {
        ReachabilityHelper.startReachability()

        return NSNotificationCenter.defaultCenter().rx_notification(ReachabilityChangedNotification, object: ReachabilityHelper.sharedReachability).map { (notification) -> Reachability in
            return notification.object as! Reachability
        }
    }
}

//ReachabilityHelper.reachabilityChangedObservable().subscribeNext { (reachability) -> Void in
//    if reachability.isReachable() {
//        if reachability.isReachableViaWiFi() {
//            println("Reachable via WiFi")
//        } else {
//            println("Reachable via Cellular")
//        }
//    } else {
//        println("Not reachable")
//    }
//}.addDisposableTo(disposeBag)
