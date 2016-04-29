//
//  BaseTableViewCell.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 8/25/15.
//  Copyright (c) 2015 Jera. All rights reserved.
//

import UIKit
import Cartography

public class BaseTableViewCell: UITableViewCell {

    public var useCustomSelectionAnimation = false
    private(set) var viewLoaded = false

    public weak var selectionView: UIView? {
        didSet {
            let selectionView = self.selectionView ?? self

            selectionView.addSubview(transparencyView)
            constrain(selectionView, transparencyView) { (selectionView, transparencyView) -> () in
                transparencyView.edges == selectionView.edges
            }
        }
    }

    public lazy var transparencyView: UIView = {
        let transparencyView = UIView()
        transparencyView.userInteractionEnabled = false
        return transparencyView
    }()

    public var selectedColor = UIColor(white: 220/255, alpha: 0.4)

    public var highlightedColor = UIColor(white: 220/255, alpha: 0.6)

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    public func commonInit() {
        selectionView = nil

        selectionStyle = .None

        backgroundColor = UIColor.clearColor()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        viewLoaded = true
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if !useCustomSelectionAnimation {
            let selectionView = self.selectionView ?? self

            selectionView.bringSubviewToFront(transparencyView)

            UIView.animateWithDuration(0.15, animations: { () -> Void in
                if selected {
                    self.transparencyView.backgroundColor = self.selectedColor
                } else {
                    if !self.highlighted {
                        self.transparencyView.backgroundColor = UIColor.clearColor()
                    }
                }
            })
        }
    }

    
    override public func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if !useCustomSelectionAnimation {
            let selectionView = self.selectionView ?? self

            selectionView.bringSubviewToFront(transparencyView)

            UIView.animateWithDuration(0.15, animations: { () -> Void in
                if highlighted {
                    self.transparencyView.backgroundColor = self.highlightedColor
                } else {
                    if !self.selected {
                        self.transparencyView.backgroundColor = UIColor.clearColor()
                    }
                }
            })
        }
    }
}
