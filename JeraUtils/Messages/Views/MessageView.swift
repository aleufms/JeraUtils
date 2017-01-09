//
//  MessageView.swift
//  beblueapp
//
//  Created by Alessandro Nakamuta on 8/27/15.
//  Copyright (c) 2015 Jera. All rights reserved.
//

import UIKit
import FontAwesome_swift

public enum MessageViewType {
    case EmptyError
    case ConnectionError
    case GenericError
    case GenericMessage
}

public class MessageView: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    
    private var reloadBlock:(()->Void)?
    
    public class func instantiateFromNib() -> MessageView {
        //        let podBundle = Bundle(for: self)
        //        if let bundleURL = podBundle.url(forResource: "JeraUtils", withExtension: "bundle") {
        //            if let bundle = Bundle(url: bundleURL) {
        return Bundle.main.loadNibNamed("MessageView", owner: nil, options: nil)!.first as! MessageView
        //            }else {
        //                assertionFailure("Could not load the bundle")
        //            }
        //        }
        //        assertionFailure("Could not create a path to the bundle")
        //        return MessageView()
        //        return NSBundle.mainBundle().loadNibNamed("MessageView", owner: nil, options: nil).first as! MessageView
    }
    
    public var color: UIColor? {
        didSet {
            refreshAppearence()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        retryButton.addTarget(self, action: #selector(MessageView.retryButtonAction), for: .touchUpInside)
    }
    
    private func refreshAppearence() {
        textLabel.textColor = color
        imageView.tintColor = color
    }
    
    public func populateWith(text: String, messageViewType: MessageViewType, reloadBlock: (()->Void)? = nil ) {
        switch messageViewType {
        case .EmptyError:
            imageView.image = UIImage.fontAwesomeIcon(name: FontAwesome.list, textColor: UIColor.black, size: CGSize(width: 41, height: 41)).withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            
        case .ConnectionError:
            imageView.image = UIImage.fontAwesomeIcon(name: FontAwesome.globe, textColor: UIColor.black, size: CGSize(width: 41, height: 41)).withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            
        case .GenericError:
            imageView.image = UIImage.fontAwesomeIcon(name: FontAwesome.exclamationCircle, textColor: UIColor.black, size: CGSize(width: 41, height: 41)).withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        case .GenericMessage:
            imageView.image = nil
        }
        
        textLabel.text = text
        
        self.reloadBlock = reloadBlock
        
        retryButton.isHidden = (reloadBlock == nil)
    }
    
    func retryButtonAction() {
        if let reloadBlock = reloadBlock {
            reloadBlock()
        }
    }
}
