//
//  InfinityScrollRefreshView.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 11/12/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import INSPullToRefresh

class InfinityScrollRefreshView: UIView {

    class func instantiateFromNib() -> InfinityScrollRefreshView {
        return NSBundle.mainBundle().loadNibNamed("InfinityScrollRefreshView", owner: nil, options: nil).first as! InfinityScrollRefreshView
    }

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

}

extension InfinityScrollRefreshView: INSInfiniteScrollBackgroundViewDelegate {
    func infinityScrollBackgroundView(infinityScrollBackgroundView: INSInfiniteScrollBackgroundView!, didChangeState state: INSInfiniteScrollBackgroundViewState) {
        switch state {
        case .None:
            activityIndicatorView.stopAnimating()
        case .Loading:
            activityIndicatorView.startAnimating()
        }
    }
}
