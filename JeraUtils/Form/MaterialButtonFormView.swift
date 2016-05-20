//
//  MaterialButtonFormView.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/18/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import Cartography
import Material

public class MaterialButtonFormView: UIView {

    public lazy var button: FlatButton = {
        let button = FlatButton()
        return button
    }()

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            refreshConstraints()
        }
    }

    public var buttonHeight: CGFloat = 56 {
        didSet {
            refreshConstraints()
        }
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public init(edgeInsets: UIEdgeInsets) {
        super.init(frame: CGRect.zero)
        self.edgeInsets = edgeInsets

        commonInit()
    }

    private func commonInit() {
        addLabel()
    }

    private func addLabel() {
        addSubview(button)

        refreshConstraints()
    }

    let group = ConstraintGroup()
    private func refreshConstraints() {
        constrain(self, button, replace: group) { (view, button) -> () in
            button.top == view.top + edgeInsets.top
            button.left == view.left + edgeInsets.left
            button.bottom == view.bottom - edgeInsets.bottom
            button.right == view.right - edgeInsets.right

            button.height == buttonHeight
        }
    }

}
