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
        let podBundle = Bundle(for: self)
        if let bundleURL = podBundle.url(forResource: "JeraUtils", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
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

        refreshImageView.image = UIImage.fontAwesomeIcon(name: .arrowCircleDown, textColor: UIColor.black, size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
        refreshImageView.tintColor = UIColor.gray
        refreshImageView.alpha = 0
    }
}

extension PullToRefreshView: INSPullToRefreshBackgroundViewDelegate {
    public func pullToRefreshBackgroundView(pullToRefreshBackgroundView: INSPullToRefreshBackgroundView!, didChangeState state: INSPullToRefreshBackgroundViewState) {
        switch state {
        case .none:
            activityIndicatorView.stopAnimating()
            refreshImageView.tintColor = UIColor.gray
        case .loading:
            activityIndicatorView.startAnimating()
            refreshImageView.alpha = 0
            refreshImageView.tintColor = UIColor.gray
        case .triggered:
            activityIndicatorView.stopAnimating()
            refreshImageView.tintColor = UIColor.darkGray
        }
    }

    public func pullToRefreshBackgroundView(pullToRefreshBackgroundView: INSPullToRefreshBackgroundView!, didChangeTriggerStateProgress progress: CGFloat) {
        refreshImageView.alpha = progress
        refreshImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) * progress)
    }
}
