//
//  BaseViewController+Messages.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 1/19/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import Cartography

public extension UIViewController {
    private struct AssociatedKey {
        static var loadingViewExtension = "loadingViewExtension"
        static var messageViewExtension = "messageViewExtension"
        static var customMessageViewExtension = "customMessageViewExtension"
        static var messageContainerViewExtension = "messageContainerViewExtension"
    }

    private var jera_loadingView: LoadingView {
        get {
            return getAssociatedObject(self, associativeKey: &AssociatedKey.loadingViewExtension) { () -> LoadingView in
                return LoadingView.instantiateFromNib()
            }
        }

        set {
            setAssociatedObject(self, value: newValue, associativeKey: &AssociatedKey.loadingViewExtension)
        }
    }

    private var jera_messageView: MessageView {
        get {
            return getAssociatedObject(self, associativeKey: &AssociatedKey.messageViewExtension) { () -> MessageView in
                return MessageView.instantiateFromNib()
            }
        }

        set {
            setAssociatedObject(self, value: newValue, associativeKey: &AssociatedKey.messageViewExtension)
        }
    }

    private var jera_customMessageView: UIView {
        get {
            return getAssociatedObject(self, associativeKey: &AssociatedKey.customMessageViewExtension) { () -> UIView in
                return UIView()
            }
        }

        set {
            setAssociatedObject(self, value: newValue, associativeKey: &AssociatedKey.customMessageViewExtension)
        }
    }

    private var jera_messageContainerView: UIView {
        get {
            return getAssociatedObject(self, associativeKey: &AssociatedKey.messageContainerViewExtension) { () -> UIView in
                let messageContainerView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))

                messageContainerView.userInteractionEnabled = true
                //                    messageContainerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                return messageContainerView
            }
        }

        set {
            setAssociatedObject(self, value: newValue, associativeKey: &AssociatedKey.messageContainerViewExtension)
        }
    }

    public func showLoadingText(text: String? = nil, color: UIColor? = nil, type: LoadingViewType? = nil, contentView: UIView? = nil, messagePosition: BaseViewControllerMessagePosition = .Center(offset: nil), contentBlocked: Bool = false) {
        hidePopupViews()

        jera_loadingView.text = text ?? I18n("messages-loading", defaultString: "Carregando...")

        jera_loadingView.setColor(color == nil ? UIColor.grayColor() : color!, type: type == nil ? .SpinKit(style: .StyleThreeBounce) : type!)

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

    public func showMessageText(text: String, color: UIColor? = nil, messageType: MessageViewType, contentView: UIView? = nil, messagePosition: BaseViewControllerMessagePosition = .Center(offset: nil), contentBlocked: Bool = false, reloadBlock: (()->Void)? = nil) {
        hidePopupViews()

        jera_messageView.populateWith(text, messageViewType: messageType, reloadBlock: reloadBlock)

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
            jera_messageView.color = UIColor.whiteColor()
            constrain(jera_messageContainerView, view) { (messageContainerView, view) -> () in
                messageContainerView.edges == view.edges
            }
        } else {
            jera_messageView.color = (color != nil) ? color : UIColor.grayColor()
        }
    }

    public func showCustomView(customView: UIView, contentView: UIView? = nil, messagePosition: BaseViewControllerMessagePosition = .Center(offset: nil), contentBlocked: Bool = false) {
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
        jera_loadingView.removeFromSuperview()
        jera_messageView.removeFromSuperview()
        jera_customMessageView.removeFromSuperview()
    }

}
