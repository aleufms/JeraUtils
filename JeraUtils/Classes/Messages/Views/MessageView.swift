//
//  MessageView.swift
//  beblueapp
//
//  Created by Alessandro Nakamuta on 8/27/15.
//  Copyright (c) 2015 Jera. All rights reserved.
//

import UIKit
import FontAwesome_swift

enum MessageViewType {
    case EmptyError
    case ConnectionError
    case GenericError
    case GenericMessage
}

class MessageView: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!

    private var reloadBlock:(()->Void)?

    class func instantiateFromNib() -> MessageView {
        return NSBundle.mainBundle().loadNibNamed("MessageView", owner: nil, options: nil).first as! MessageView
    }

    var color: UIColor? {
        didSet {
            refreshAppearence()
        }
    }

    private func refreshAppearence() {
        textLabel.textColor = color
        imageView.tintColor = color
    }

    func populateWith(text: String, messageViewType: MessageViewType, reloadBlock: (()->Void)? = nil ) {
        switch messageViewType {
        case .EmptyError:
            imageView.image = UIImage.fontAwesomeIconWithName(FontAwesome.List, textColor: UIColor.blackColor(), size: CGSize(width: 41, height: 41)).imageWithRenderingMode(.AlwaysTemplate)
            imageView.tintColor = color

        case .ConnectionError:
            imageView.image = UIImage.fontAwesomeIconWithName(FontAwesome.Globe, textColor: UIColor.blackColor(), size: CGSize(width: 41, height: 41)).imageWithRenderingMode(.AlwaysTemplate)
            imageView.tintColor = color

        case .GenericError:
            imageView.image = UIImage.fontAwesomeIconWithName(FontAwesome.ExclamationCircle, textColor: UIColor.blackColor(), size: CGSize(width: 41, height: 41)).imageWithRenderingMode(.AlwaysTemplate)
            imageView.tintColor = color
        case .GenericMessage:
            imageView.image = nil
        }

        textLabel.text = text

        self.reloadBlock = reloadBlock

        retryButton.hidden = (reloadBlock == nil)
    }

    @IBAction func retryButtonAction(sender: AnyObject) {
        if let reloadBlock = reloadBlock {
            reloadBlock()
        }
    }
}
