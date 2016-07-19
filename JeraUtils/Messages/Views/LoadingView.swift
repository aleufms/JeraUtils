//
//  LoadingView.swift
//  beblueapp
//
//  Created by Alessandro Nakamuta on 8/27/15.
//  Copyright (c) 2015 Jera. All rights reserved.
//

import UIKit
import SpinKit
import Cartography

public enum LoadingViewType {
    case Compass
    case SpinKit(style: RTSpinKitViewStyle)
    case Image(image: UIImage)
}

public class LoadingView: UIView {

    public class func instantiateFromNib() -> LoadingView {
        
        let podBundle = NSBundle(forClass: self)
        if let bundleURL = podBundle.URLForResource("JeraUtils", withExtension: "bundle") {
            if let bundle = NSBundle(URL: bundleURL) {
                return bundle.loadNibNamed("LoadingView", owner: nil, options: nil).first as! LoadingView
            }else {
                assertionFailure("Could not load the bundle")
            }
        }
        assertionFailure("Could not create a path to the bundle")
        return LoadingView()
    }

    public var text: String? {
        didSet {
            textLabel.text = text
        }
    }

    private var color: UIColor?
    private var type: LoadingViewType?

    @IBOutlet private weak var activityIndicatorContainerView: UIView!
    @IBOutlet private weak var textLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        //        refreshAppearence()
    }

    public func setColor(color: UIColor, type: LoadingViewType) {
        textLabel.textColor = color

        clearActivityIndicatorContainer()
        switch type {
        case .Compass:
            let compassImageView = UIImageView(image: UIImage.bundleImage(named: "ic_compass"))
            activityIndicatorContainerView.addSubview(compassImageView)
            compassImageView.tintColor = color

            constrain(compassImageView, activityIndicatorContainerView, block: { (compassImageView, activityIndicatorContainerView) -> () in
                compassImageView.centerX == activityIndicatorContainerView.centerX
                compassImageView.top == activityIndicatorContainerView.top
                compassImageView.bottom == activityIndicatorContainerView.bottom - 8
            })

            compassAnimationView(compassImageView)
        case .SpinKit(let style):
            let spinKitView = RTSpinKitView(style: style)
            activityIndicatorContainerView.addSubview(spinKitView)
            spinKitView.color = color
            spinKitView.startAnimating()

            constrain(spinKitView, activityIndicatorContainerView, block: { (spinKitView, activityIndicatorContainerView) -> () in
                spinKitView.centerX == activityIndicatorContainerView.centerX
                spinKitView.top == activityIndicatorContainerView.top
                spinKitView.bottom == activityIndicatorContainerView.bottom - 8
                spinKitView.height == 22
            })
        case .Image(let image):
            let imageView = UIImageView(image: image.imageWithRenderingMode(.AlwaysTemplate))
            activityIndicatorContainerView.addSubview(imageView)
            //            imageView.backgroundColor = UIColor.blueColor()
            imageView.tintColor = color
            //            spinKitView.startAnimating()
            
            constrain(imageView, activityIndicatorContainerView, block: { (imageView, activityIndicatorContainerView) -> () in
                imageView.centerX == activityIndicatorContainerView.centerX
                imageView.top == activityIndicatorContainerView.top
                imageView.bottom == activityIndicatorContainerView.bottom - 8
                imageView.height == 22
                imageView.width == 22
            })
            
            runSpinAnimationOnView(imageView, duration: 1)
        }
    }
    
    private func runSpinAnimationOnView(view: UIView, duration: Double){
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI * 2
        rotationAnimation.duration = duration
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = 10000
        
        view.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }

    private func clearActivityIndicatorContainer() {
        for subviewObject in activityIndicatorContainerView.subviews {
            subviewObject.removeFromSuperview()
        }
    }

    private func compassAnimationView(view: UIView) {
        // angles in iOS are measured as radians PI is 180 degrees so PI × 2 is 360 degrees
        let fullRotation = CGFloat(M_PI * 2)

        let duration = 2.0
        let delay = 0.0
        let options: UIViewKeyframeAnimationOptions = [UIViewKeyframeAnimationOptions.CalculationModePaced, UIViewKeyframeAnimationOptions.Repeat]

        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                view.transform = CGAffineTransformMakeRotation(1/12 * fullRotation)
            })

            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                view.transform = CGAffineTransformMakeRotation(-1/12 * fullRotation)
            })

            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                view.transform = CGAffineTransformMakeRotation(1/6 * fullRotation)
            })

            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                view.transform = CGAffineTransformMakeRotation(2/6 * fullRotation)
            })

            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                view.transform = CGAffineTransformMakeRotation(3/6 * fullRotation)
            })

            }, completion: nil)
    }

}
