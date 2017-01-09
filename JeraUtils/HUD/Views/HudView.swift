//
//  HudView.swift
//  beblueapp
//
//  Created by Alessandro Nakamuta on 9/16/15.
//  Copyright © 2015 BeBlue. All rights reserved.
//

import UIKit
import Cartography
import SpinKit
import FontAwesome_swift

public class HudView: UIView {

    class func instantiateFromNib() -> HudView {
        let podBundle = Bundle(for: self)
        if let bundleURL = podBundle.url(forResource: "JeraUtils", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return bundle.loadNibNamed("HudView", owner: nil, options: nil)!.first as! HudView
            }else {
                assertionFailure("Could not load the bundle")
            }
        }
        assertionFailure("Could not create a path to the bundle")
        return HudView()
//        return NSBundle.mainBundle().loadNibNamed("HudView", owner: nil, options: nil).first as! HudView
    }

    @IBOutlet private weak var customViewContainer: UIView!
    @IBOutlet private weak var textLabel: UILabel!

    private let customViewConstraintGroup = ConstraintGroup()

    private var customView: UIView? {
        willSet {
            if let customView = customView {
                customView.removeFromSuperview()
            }
        }
        didSet {
            if let customView = customView {
                self.customViewContainer.addSubview(customView)
                setNeedsUpdateConstraints()
            }
        }
    }

    private var customViewBorderInset = UIEdgeInsets.zero {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor(white: 1, alpha: 0.85)
        layer.cornerRadius = 5
    }

    override public func updateConstraints() {
        super.updateConstraints()

        if let customView = customView {
            constrain(customViewContainer, customView, replace: customViewConstraintGroup, block: { (customViewContainer, customView) -> () in
                customView.left == customViewContainer.left + customViewBorderInset.left
                customView.right == customViewContainer.right - customViewBorderInset.right
                customView.top == customViewContainer.top + customViewBorderInset.top
                customView.bottom == customViewContainer.bottom - customViewBorderInset.bottom
            })
        }
    }

    public func populateWithText(text: String, customView: UIView?, customViewBorderInset: UIEdgeInsets = UIEdgeInsets.zero) {
        textLabel.text = text
        self.customView = customView
        self.customViewBorderInset = customViewBorderInset
    }
}

public extension HudView {
    public class func loadingHudView(text text: String) -> HudView {
        let hudView = HudView.instantiateFromNib()

        let loadingContainerView = UIView()
        let loadingView = RTSpinKitView(style: .styleThreeBounce, color: UIColor.gray)
        loadingContainerView.addSubview(loadingView!)
        constrain(loadingContainerView, loadingView!) { (loadingContainerView, loadingView) -> () in
            loadingView.center == loadingContainerView.center
            loadingView.top >= loadingContainerView.top
            loadingView.bottom >= loadingContainerView.bottom
        }

        hudView.populateWithText(text: text, customView: loadingContainerView)

        return hudView
    }

    public class func successHudView(text text: String) -> HudView {
        let baseHudView = HudView.instantiateFromNib()

        let successImageContainerView = UIView()
        
        let successImage = UIImage.fontAwesomeIcon(name: FontAwesome.checkCircle, textColor: UIColor.white, size: CGSize(width: 44, height: 44))
        
        let successImageView = UIImageView(image: successImage.withRenderingMode(.alwaysTemplate))
        successImageView.tintColor = UIColor.gray
        successImageContainerView.addSubview(successImageView)
        constrain(successImageContainerView, successImageView) { (successImageContainerView, successImageView) -> () in
            successImageView.center == successImageContainerView.center
            successImageView.top >= successImageContainerView.top
            successImageView.bottom >= successImageContainerView.bottom
        }

        baseHudView.populateWithText(text: text, customView: successImageContainerView)

        return baseHudView
    }

    public class func progressHudView(text text: String) -> (HudView, UIProgressView) {
        let baseHudView = HudView.instantiateFromNib()

        let progressView = UIProgressView(progressViewStyle: .default)

        baseHudView.populateWithText(text: text, customView: progressView, customViewBorderInset: UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8))

        return (baseHudView, progressView)
    }
}

public extension HudManager {
    public func showLoading(status status: String? = nil) -> UIView {
        let loadingHudView: HudView
        if let status = status {
            loadingHudView = HudView.loadingHudView(text: status)
        } else {
            loadingHudView = HudView.loadingHudView(text: I18n(localizableString: "hud-loading", defaultString: "Carregando..."))
        }

        self.showCustomView(customView: loadingHudView)

        return loadingHudView
    }

    public func showSuccessToastWithStatus(status: String, dismissAfter: Double? = 2) -> UIView {
        let successHudView = HudView.successHudView(text: status)

        self.showCustomView(customView: successHudView, dismissAfter: dismissAfter)

        return successHudView
    }

    public func showProgress(status: String) -> UIProgressView {
        let (progressHudView, progressView) = HudView.progressHudView(text: status)

        self.showCustomView(customView: progressHudView)

        return progressView
    }
}
