//
//  BaseViewController+Messages.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 1/19/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import Cartography

public enum ViewControllerMessagePosition {
    case Center(offset: CGPoint?)
    case Top(topOffset: CGFloat?)
    case CenterAndSides(centerOffset: CGPoint?, sideOffsets: CGFloat?)
    //    case Custom(topOffset: CGFloat)
}

public extension UIViewController {
    private struct AssociatedKeys {
        static var loadingViewExtension = "loadingViewExtension"
        static var messageViewExtension = "messageViewExtension"
        static var customMessageViewExtension = "customMessageViewExtension"
        static var messageContainerViewExtension = "messageContainerViewExtension"
    }
    
    private var jera_loadingView: LoadingView? {
        get {
            return getAssociated(associativeKey: &AssociatedKeys.loadingViewExtension)
        }
        
        set {
            setAssociated(value: newValue, associativeKey: &AssociatedKeys.loadingViewExtension)
        }
    }
    
    private var jera_messageView: MessageView? {
        get {
            return getAssociated(associativeKey: &AssociatedKeys.messageViewExtension)
        }
        
        set {
            setAssociated(value: newValue, associativeKey: &AssociatedKeys.messageViewExtension)
        }
    }
    
    private var jera_customMessageView: UIView? {
        get {
            return getAssociated(associativeKey: &AssociatedKeys.customMessageViewExtension)
        }
        
        set {
            setAssociated(value: newValue, associativeKey: &AssociatedKeys.customMessageViewExtension)
        }
    }
    
    private var jera_messageContainerView: UIView {
        get {
            let associatedView: UIView? = getAssociated(associativeKey: &AssociatedKeys.messageContainerViewExtension)
            
            if let associatedView = associatedView{
                return associatedView
            }else{
                let messageContainerView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
                
                messageContainerView.isUserInteractionEnabled = true
                
                return messageContainerView
            }
        }
        
        set {
            setAssociated(value: newValue, associativeKey: &AssociatedKeys.messageContainerViewExtension)
        }
    }
    
    /**
     Shows an animated loading message.
     
     - parameter text:            The text to be shown in the loading message
     - parameter color:           The color of the text to be shown
     - parameter type:            The type of the loadingView. Receives a LoadingViewType, which can be an animated compass or a RTSpinKitViewStyle. The LoadingViewType is set to RTSpinKitViewStyle.StyleThreeBounce by default.
     - parameter contentView:     The view which will show the loading message. The message will be shown in the view of the ViewController who invoqued it by default.
     - parameter messagePosition: A position used to layout the loading message. It will layout it in the middle of the view by default.
     - parameter contentBlocked:  A boolean to whether the loading message will block user interaction or not. It is set to false by default.
     */
    public func showLoadingText(text: String = "Carregando...", color: UIColor = UIColor.gray, type: LoadingViewType? = nil, contentView: UIView? = nil, messagePosition: ViewControllerMessagePosition = .Center(offset: nil), contentBlocked: Bool = false) {
        hidePopupViews()
        if jera_loadingView == nil{
            jera_loadingView = LoadingView.instantiateFromNib()
        }
        guard let jera_loadingView = jera_loadingView else { return }
        
        jera_loadingView.text = text
        
        jera_loadingView.setColor(color: color, type: type == nil ? .SpinKit(style: .styleThreeBounce) : type!)
        
        let view: UIView
        if let contentView = contentView {
            view = contentView
        } else {
            view = self.view
        }
        
        view.addSubview(jera_loadingView)
        
        constrain(jera_loadingView, view, block: { (loadingView, view) -> () in
            switch messagePosition {
            case .Center(let offset):
                if let offset = offset {
                    loadingView.centerX == view.centerX + offset.x
                    loadingView.centerY == view.centerY + offset.y
                } else {
                    loadingView.center == view.center
                }
            case .Top(let topOffset):
                if let topOffset = topOffset {
                    loadingView.top == view.top + topOffset
                } else {
                    loadingView.top == view.top + 8
                }
                loadingView.centerX == view.centerX
            case .CenterAndSides(let centerOffset, let sideOffsets):
                if let centerOffset = centerOffset {
                    loadingView.centerX == view.centerX + centerOffset.x
                    loadingView.centerY == view.centerY + centerOffset.y
                } else {
                    loadingView.center == view.center
                }
                if let sideOffsets = sideOffsets {
                    loadingView.left == view.left + sideOffsets
                    loadingView.right == view.right - sideOffsets
                }
            }
        })
        
        if contentBlocked {
            view.insertSubview(jera_messageContainerView, belowSubview: jera_loadingView)
            constrain(jera_messageContainerView, view) { (messageContainerView, view) -> () in
                messageContainerView.edges == view.edges
            }
        }
    }
    
    /**
     Shows a message in the view. It's main purpose is to show connection problems messages. The message will usually contain a try again button.
     
     - parameter text: The text to be shown as a message
     - parameter color: The color of the text to be shown
     - parameter messageType: The type of the message. For detailed description check MessageViewType enum.
     - parameter contentView: The view which will show the message. The message will be shown in the view of the ViewController who invoked it by default.
     - parameter messagePosition: A position used to layout the loading message. It will layout it in the middle of the view by default.
     - parameter contentBlocked:  A boolean to whether the loading message will block user interaction or not. It is set to false by default.
     - parameter reloadBlock: A block of code to be executed when the try again button is tapped.
     */
    public func showMessageText(text: String, color: UIColor? = nil, messageType: MessageViewType, contentView: UIView? = nil, messagePosition: ViewControllerMessagePosition = .Center(offset: nil), contentBlocked: Bool = false, reloadBlock: (()->Void)? = nil) {
        hidePopupViews()
        if jera_messageView == nil{
            jera_messageView = MessageView.instantiateFromNib()
        }
        guard let jera_messageView = jera_messageView else { return }
        
        jera_messageView.populateWith(text: text, messageViewType: messageType, reloadBlock: reloadBlock)
        
        let view: UIView
        if let contentView = contentView {
            view = contentView
        } else {
            view = self.view
        }
        
        view.addSubview(jera_messageView)
        
        constrain(jera_messageView, view) { (messageView, view) -> () in
            switch messagePosition {
            case .Center(let offset):
                if let offset = offset {
                    messageView.centerX == view.centerX + offset.x
                    messageView.centerY == view.centerY + offset.y
                } else {
                    messageView.center == view.center
                }
            case .Top(let topOffset):
                if let topOffset = topOffset {
                    messageView.top == view.top + topOffset
                } else {
                    messageView.top == view.top + 8
                }
                messageView.centerX == view.centerX
            case .CenterAndSides(let centerOffset, let sideOffsets):
                if let centerOffset = centerOffset {
                    messageView.centerX == view.centerX + centerOffset.x
                    messageView.centerY == view.centerY + centerOffset.y
                } else {
                    messageView.center == view.center
                }
                if let sideOffsets = sideOffsets {
                    messageView.left == view.left + sideOffsets
                    messageView.right == view.right - sideOffsets
                }
            }
        }
        
        if contentBlocked {
            view.insertSubview(jera_messageContainerView, belowSubview: jera_messageView)
            jera_messageView.color = UIColor.white
            constrain(jera_messageContainerView, view) { (messageContainerView, view) -> () in
                messageContainerView.edges == view.edges
            }
        } else {
            jera_messageView.color = (color != nil) ? color : UIColor.gray
        }
    }
    
    public func showCustomView(customView: UIView, contentView: UIView? = nil, messagePosition: ViewControllerMessagePosition = .Center(offset: nil), contentBlocked: Bool = false) {
        hidePopupViews()
        
        let view: UIView
        if let contentView = contentView {
            view = contentView
        } else {
            view = self.view
        }
        
        jera_customMessageView = customView
        
        view.addSubview(customView)
        
        constrain(customView, view, block: { (customView, view) -> () in
            switch messagePosition {
            case .Center(let offset):
                if let offset = offset {
                    customView.centerX == view.centerX + offset.x
                    customView.centerY == view.centerY + offset.y
                } else {
                    customView.center == view.center
                }
            case .Top(let topOffset):
                if let topOffset = topOffset {
                    customView.top == view.top + topOffset
                } else {
                    customView.top == view.top + 8
                }
                customView.centerX == view.centerX
            case .CenterAndSides(let centerOffset, let sideOffsets):
                if let centerOffset = centerOffset {
                    customView.centerX == view.centerX + centerOffset.x
                    customView.centerY == view.centerY + centerOffset.y
                } else {
                    customView.center == view.center
                }
                if let sideOffsets = sideOffsets {
                    customView.left == view.left + sideOffsets
                    customView.right == view.right - sideOffsets
                }
            }
        })
        
        if contentBlocked {
            view.insertSubview(jera_messageContainerView, belowSubview: customView)
            constrain(jera_messageContainerView, view) { (messageContainerView, view) -> () in
                messageContainerView.edges == view.edges
            }
        }
    }
    
    public func hidePopupViews() {
        jera_messageContainerView.removeFromSuperview()
        
        jera_loadingView?.removeFromSuperview()
        jera_loadingView = nil
        
        jera_messageView?.removeFromSuperview()
        jera_messageView = nil
        
        jera_customMessageView?.removeFromSuperview()
        jera_customMessageView = nil
    }
    
}
