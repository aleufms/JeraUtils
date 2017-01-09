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
        return Reachability.init()
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

        return NotificationCenter.default.rx.notification(ReachabilityChangedNotification, object: ReachabilityHelper.sharedReachability).map { (notification) -> Reachability in
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
