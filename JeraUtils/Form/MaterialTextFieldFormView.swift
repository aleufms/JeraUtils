//
//  MaterialTextFieldFormView.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/17/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import Material
import Cartography

import RxSwift
import RxCocoa
import NSStringMask

public class MaterialTextFieldFormView: UIView {

    public lazy var textField: TextField = {
        let textField = TextField()
        return textField
    }()

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20) {
        didSet {
            refreshConstraints()
        }
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
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
        addTextField()
        
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapAction"))
    }
    
    private func tapAction(){
        textField.becomeFirstResponder()
    }

    private func addTextField() {
        addSubview(textField)

        refreshConstraints()
    }

    let group = ConstraintGroup()
    private func refreshConstraints() {
        constrain(self, textField, replace: group) { (view, textField) -> () in
            textField.top == view.top + edgeInsets.top
            textField.left == view.left + edgeInsets.left
            textField.bottom == view.bottom - edgeInsets.bottom
            textField.right == view.right - edgeInsets.right
        }
    }

}

public class MaterialMaskFieldFormView: UIView {

    public lazy var textField: MaterialMaskTextField = {
        let textField = MaterialMaskTextField()
        return textField
    }()

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20) {
        didSet {
            refreshConstraints()
        }
    }

    convenience public init() {
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
        addTextField()
        
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapAction"))
    }
    
    private func tapAction(){
        textField.becomeFirstResponder()
    }

    private func addTextField() {
        addSubview(textField)

        refreshConstraints()
    }

    let group = ConstraintGroup()
    private func refreshConstraints() {
        constrain(self, textField, replace: group) { (view, textField) -> () in
            textField.top == view.top + edgeInsets.top
            textField.left == view.left + edgeInsets.left
            textField.bottom == view.bottom - edgeInsets.bottom
            textField.right == view.right - edgeInsets.right
        }
    }

}

public class MaterialDataFieldFormView: UIView {

    public lazy var textField: MaterialDateTextField = {
        let textField = MaterialDateTextField()
        return textField
    }()

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20) {
        didSet {
            refreshConstraints()
        }
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
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
        addTextField()
        
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapAction"))
    }
    
    private func tapAction(){
        textField.becomeFirstResponder()
    }

    private func addTextField() {
        addSubview(textField)

        refreshConstraints()
    }

    let group = ConstraintGroup()
    private func refreshConstraints() {
        constrain(self, textField, replace: group) { (view, textField) -> () in
            textField.top == view.top + edgeInsets.top
            textField.left == view.left + edgeInsets.left
            textField.bottom == view.bottom - edgeInsets.bottom
            textField.right == view.right - edgeInsets.right
        }
    }

}
