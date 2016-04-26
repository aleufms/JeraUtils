//
//  MaterialLabelFormView.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/18/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import Cartography

public class MaterialLabelFormView: UIView {

    public lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) {
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

    required public init?(coder aDecoder: NSCoder) {
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
        addSubview(label)

        refreshConstraints()
    }

    let group = ConstraintGroup()
    private func refreshConstraints() {
        constrain(self, label, replace: group) { (view, label) -> () in
            label.top == view.top + edgeInsets.top
            label.left == view.left + edgeInsets.left
            label.bottom == view.bottom - edgeInsets.bottom
            label.right == view.right - edgeInsets.right
        }
    }
}
