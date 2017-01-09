//
//  BaseAlertViewController.swift
//  Pods
//
//  Created by Alessandro Nakamuta on 5/24/16.
//
//

import UIKit
import Cartography
import RxSwift

public class BaseAlertViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let bottomInsetConstraintGroup = ConstraintGroup()
    
    private(set) var keyboardRect = CGRect.zero
    
    private lazy var visibleView: UIView = {
        let visibleView = UIView(frame: self.view.frame)
        self.view.addSubview(visibleView)
        constrain(self.view, visibleView, block: { (view, visibleView) -> () in
            visibleView.top == view.top
            visibleView.left == view.left
            visibleView.right == view.right
        })
        
        return visibleView
    }()
    
    public var alertView: UIView?{
        didSet{
            if let alertView = alertView{
                visibleView.addSubview(alertView)
                constrain(visibleView, alertView, block: { (visibleView, alertView) -> () in
                    alertView.left >= visibleView.left
                    alertView.right <= visibleView.right
                    alertView.top >= visibleView.top
                    alertView.bottom <= visibleView.bottom
                    alertView.center == visibleView.center
                })
                
            }
        }
    }
    
    public override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constrain(view, visibleView, replace: bottomInsetConstraintGroup, block: { (view, visibleView) -> () in
            visibleView.bottom == view.bottom - keyboardRect.size.height
        })
    }
    
    public override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0, alpha: 0)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillChangeFrame).subscribe(onNext: { [weak self] (notification) in
            if let strongSelf = self{
                if let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
                    strongSelf.keyboardRect = keyboardRect
                }
                
                strongSelf.view.setNeedsUpdateConstraints()
            }
         }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext: { [weak self] (notification) in
            if let strongSelf = self{
                strongSelf.keyboardRect = CGRect.zero
                
                strongSelf.view.setNeedsUpdateConstraints()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)

    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
