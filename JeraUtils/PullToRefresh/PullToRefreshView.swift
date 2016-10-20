//
//  PullToRefreshView.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 11/11/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import INSPullToRefresh
import FontAwesome_swift

public class PullToRefreshView: UIView {

    public class func instantiateFromNib() -> PullToRefreshView {
        let podBundle = NSBundle(forClass: self)
        if let bundleURL = podBundle.URLForResource("JeraUtils", withExtension: "bundle") {
            if let bundle = NSBundle(URL: bundleURL) {
                return bundle.loadNibNamed("PullToRefreshView", owner: nil, options: nil)!.first as! PullToRefreshView
            }else {
                assertionFailure("Could not load the bundle")
            }
        }
        assertionFailure("Could not create a path to the bundle")
        return PullToRefreshView()
//        return NSBundle.mainBundle().loadNibNamed("PullToRefreshView", owner: nil, options: nil).first as! PullToRefreshView
    }

    @IBOutlet weak var refreshImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override public func awakeFromNib() {
        super.awakeFromNib()

        refreshImageView.image = UIImage.fontAwesomeIconWithName(.ArrowCircleDown, textColor: UIColor.blackColor(), size: CGSize(width: 30, height: 30)).imageWithRenderingMode(.AlwaysTemplate)
        refreshImageView.tintColor = UIColor.grayColor()
        refreshImageView.alpha = 0
    }
}

extension PullToRefreshView: INSPullToRefreshBackgroundViewDelegate {
    public func pullToRefreshBackgroundView(pullToRefreshBackgroundView: INSPullToRefreshBackgroundView!, didChangeState state: INSPullToRefreshBackgroundViewState) {
        switch state {
        case .None:
            activityIndicatorView.stopAnimating()
            refreshImageView.tintColor = UIColor.grayColor()
        case .Loading:
            activityIndicatorView.startAnimating()
            refreshImageView.alpha = 0
            refreshImageView.tintColor = UIColor.grayColor()
        case .Triggered:
            activityIndicatorView.stopAnimating()
            refreshImageView.tintColor = UIColor.darkGrayColor()
        }
    }

    public func pullToRefreshBackgroundView(pullToRefreshBackgroundView: INSPullToRefreshBackgroundView!, didChangeTriggerStateProgress progress: CGFloat) {
        refreshImageView.alpha = progress
        refreshImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * progress)
    }
}
