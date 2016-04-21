//
//  MaterialTextFieldFormView.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/17/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import MK
import Cartography

import RxSwift
import RxCocoa
import NSStringMask

class MaterialTextFieldFormView: UIView {
    
    lazy var textField: TextField = {
        let textField = TextField()
        return textField
    }()
    
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20){
        didSet{
            refreshConstraints()
        }
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(edgeInsets: UIEdgeInsets){
        super.init(frame: CGRectZero)
        self.edgeInsets = edgeInsets
        
        commonInit()
    }
    
    private func commonInit(){
        addTextField()
        
        self.tap { [weak self] (_) -> Void in
            self?.textField.becomeFirstResponder()
        }
    }
    
    private func addTextField(){
        addSubview(textField)
        
        refreshConstraints()
    }
    
    let group = ConstraintGroup()
    private func refreshConstraints(){
        constrain(self, textField, replace: group) { (view, textField) -> () in
            textField.top == view.top + edgeInsets.top
            textField.left == view.left + edgeInsets.left
            textField.bottom == view.bottom - edgeInsets.bottom
            textField.right == view.right - edgeInsets.right
        }
    }
    
}

class MaterialMaskFieldFormView: UIView {

    lazy var textField: MaterialMaskTextField = {
        let textField = MaterialMaskTextField()
        return textField
    }()
    
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20){
        didSet{
            refreshConstraints()
        }
    }

    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(edgeInsets: UIEdgeInsets){
        super.init(frame: CGRectZero)
        self.edgeInsets = edgeInsets
        
        commonInit()
    }
    
    private func commonInit(){
        addTextField()
        
        self.tap { [weak self] (_) -> Void in
            self?.textField.becomeFirstResponder()
        }
    }
    
    private func addTextField(){
        addSubview(textField)
        
        refreshConstraints()
    }
    
    let group = ConstraintGroup()
    private func refreshConstraints(){
        constrain(self, textField, replace: group) { (view, textField) -> () in
            textField.top == view.top + edgeInsets.top
            textField.left == view.left + edgeInsets.left
            textField.bottom == view.bottom - edgeInsets.bottom
            textField.right == view.right - edgeInsets.right
        }
    }

}

class MaterialDataFieldFormView: UIView {
    
    lazy var textField: MaterialDateTextField = {
        let textField = MaterialDateTextField()
        return textField
    }()
    
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20){
        didSet{
            refreshConstraints()
        }
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(edgeInsets: UIEdgeInsets){
        super.init(frame: CGRectZero)
        self.edgeInsets = edgeInsets
        
        commonInit()
    }
    
    private func commonInit(){
        addTextField()
        
        self.tap { [weak self] (_) -> Void in
            self?.textField.becomeFirstResponder()
        }
    }
    
    private func addTextField(){
        addSubview(textField)
        
        refreshConstraints()
    }
    
    let group = ConstraintGroup()
    private func refreshConstraints(){
        constrain(self, textField, replace: group) { (view, textField) -> () in
            textField.top == view.top + edgeInsets.top
            textField.left == view.left + edgeInsets.left
            textField.bottom == view.bottom - edgeInsets.bottom
            textField.right == view.right - edgeInsets.right
        }
    }
    
}