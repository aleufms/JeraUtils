//
//  HudToast.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/5/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit

public class HudToast: UIView {
    class func instantiateFromNib() -> HudToast {
        let podBundle = Bundle(for: self)
        if let bundleURL = podBundle.url(forResource: "JeraUtils", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return bundle.loadNibNamed("HudToast", owner: nil, options: nil)!.first as! HudToast
            }else {
                assertionFailure("Could not load the bundle")
            }
        }
        assertionFailure("Could not create a path to the bundle")
        return HudToast()
//        return NSBundle.mainBundle().loadNibNamed("HudToast", owner: nil, options: nil).first as! HudToast
    }

    @IBOutlet private weak var label: UILabel!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightLayoutConstraint: NSLayoutConstraint!

    class func toastHudView(text text: String, font: UIFont? = nil, textColor: UIColor? = nil, backgroundColor: UIColor? = nil, borderInset: UIEdgeInsets? = nil) -> HudToast {
        let hudToast = HudToast.instantiateFromNib()
        hudToast.label.numberOfLines = 3
        hudToast.layer.cornerRadius = 5
        hudToast.populateWithText(text: text, font: font, textColor: textColor, backgroundColor: backgroundColor, borderInset: borderInset)
        return hudToast
    }

    private func populateWithText(text: String, font: UIFont? = nil, textColor: UIColor? = nil, backgroundColor: UIColor? = nil, borderInset: UIEdgeInsets? = nil) {
        label.text = text

        if let font = font {
            label.font = font
        }

        if let textColor = textColor {
            label.textColor = textColor
        }

        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }

        if let borderInset = borderInset {
            topLayoutConstraint.constant = borderInset.top
            leftLayoutConstraint.constant = borderInset.left
            bottomLayoutConstraint.constant = borderInset.bottom
            rightLayoutConstraint.constant = borderInset.right
        }
    }
}

public extension HudManager {
    /**
     Shows a text HudView as a toast.
     
     - parameter text: The text to be shown in the toast view.
     - parameter dismissAfter: Duration of the toast in seconds. Default duration is 3.5sec.
     
     - returns: Returns the toast view.
     */
    public func showToastWithText(text: String, dismissAfter: Double = 3.5) -> HudToast {
        let label = HudToast.toastHudView(text: text)
        HudManager.sharedManager.showCustomView(customView: label, dismissAfter: dismissAfter, userInteractionEnabled: false, customLayout: HudViewController.bottomLayout())
        return label
    }
}
