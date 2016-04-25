//
//  AnalyticsHelper.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/26/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import Google

//MARK: Google Analytics
extension Helper{
    class func configureGoogleAnalytics(){
        // Configure tracker from GoogleService-Info.plist.
//        var configureError:NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
//
//        // Optional: configure GAI options.
//        let gai = GAI.sharedInstance()
//            gai.trackUncaughtExceptions = true  // report uncaught exceptions
//        #if DEBUG
//            gai.logger.logLevel = GAILogLevel.Verbose
//        #endif
        
        
        //For when only using GoogleAnalytics pod
        let gai = GAI.sharedInstance()
//        gai.trackUncaughtExceptions = true
        gai.trackerWithTrackingId("UA-74352447-1")
        #if DEBUG
            gai.logger.logLevel = GAILogLevel.Verbose
        #endif
    }
    
    class func analyticsRegisterScreenName(screenName: String){
        if let tracker = GAI.sharedInstance().defaultTracker{
            tracker.set(kGAIScreenName, value: screenName)
            
            let eventTracker: NSObject = GAIDictionaryBuilder.createScreenView().build()
            tracker.send(eventTracker as! [NSObject : AnyObject])
        }
    }
}