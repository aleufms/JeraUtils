//
//  PullToRefreshExtensions.swift
//  Ativoapp
//
//  Created by Alessandro Nakamuta on 11/11/15.
//  Copyright © 2015 Ativo. All rights reserved.
//

import UIKit
import INSPullToRefresh
import Cartography

public class PullToRefreshHelper {
    /**
     Adds pullToRefresh capabilities to your ScrollView.
     - parameter scrollView: The scrollView in which you want to add PullToRefresh capabilities to.
     - parameter handler: The block of code to be executed whenever there's a pull to refresh action.
    */
    public class func addPullToRefreshToScrollView(scrollView: UIScrollView, handler: (UIScrollView!) -> Void) {
        let pullToRefreshView = PullToRefreshView.instantiateFromNib()

        scrollView.ins_addPullToRefreshWithHeight(pullToRefreshView.frame.height) { (scrollView) -> Void in
            if let scrollView = scrollView {
                handler(scrollView)
            }
        }

        scrollView.ins_pullToRefreshBackgroundView.delegate = pullToRefreshView
        scrollView.ins_pullToRefreshBackgroundView.addSubview(pullToRefreshView)
        constrain(scrollView.ins_pullToRefreshBackgroundView, pullToRefreshView) { (pullToRefreshBackgroundView, pullToRefreshView) -> () in
            pullToRefreshView.edges == pullToRefreshBackgroundView.edges
        }
    }

    /**
     Adds pagination capabilities to your ScrollView.
     - parameter scrollView: The scrollView in which you want to add pagination capabilities to.
     - parameter handler: The block of code to be executed whenever there's a pull to refresh action.
    */
    public class func addInfinityScrollRefreshView(scrollView: UIScrollView, handler: (UIScrollView!) -> Void) {
        let infinityScrollRefreshView = InfinityScrollRefreshView.instantiateFromNib()

        scrollView.ins_addInfinityScrollWithHeight(infinityScrollRefreshView.frame.height) { (scrollView) -> Void in
            if let scrollView = scrollView {
                handler(scrollView)
            }
        }

        scrollView.ins_infiniteScrollBackgroundView.delegate = infinityScrollRefreshView
        scrollView.ins_infiniteScrollBackgroundView.addSubview(infinityScrollRefreshView)
        scrollView.ins_infiniteScrollBackgroundView.additionalBottomOffsetForInfinityScrollTrigger = 500
        constrain(scrollView.ins_infiniteScrollBackgroundView, infinityScrollRefreshView) { (infiniteScrollBackgroundView, infinityScrollRefreshView) -> () in
            infinityScrollRefreshView.edges == infiniteScrollBackgroundView.edges
        }
    }
}
