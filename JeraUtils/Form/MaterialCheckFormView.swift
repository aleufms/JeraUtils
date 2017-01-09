//
//  MaterialCheckFormView.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/17/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import Material
import FontAwesome_swift
//import Tactile
import RxSwift

public class MaterialCheckFormView: UIView {
    
    public class func instantiateFromNib() -> MaterialCheckFormView {
        let podBundle = Bundle(for: self)
        if let bundleURL = podBundle.url(forResource: "JeraUtils", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return bundle.loadNibNamed("MaterialCheckFormView", owner: nil, options: nil)!.first as! MaterialCheckFormView
            }else {
                assertionFailure("Could not load the bundle")
            }
        }
        assertionFailure("Could not create a path to the bundle")
        return MaterialCheckFormView()
    }

    @IBOutlet public weak var checkImageView: UIImageView!
    @IBOutlet public weak var textLabel: UILabel!

    let disposeBag = DisposeBag()
    public let rx_checked = Variable(false)

    public var checkedImage = UIImage.fontAwesomeIcon(name: FontAwesome.checkSquareO, textColor: UIColor.gray, size: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate) {
        didSet {
            refreshCheckImageView()
        }
    }

    public var uncheckedImage = UIImage.fontAwesomeIcon(name: FontAwesome.squareO, textColor: UIColor.gray, size: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate) {
        didSet {
            refreshCheckImageView()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        refreshCheckImageView()
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MaterialCheckFormView.toogleCheckedValue)))

//        self.tap { [weak self] (_) -> Void in
//            if let strongSelf = self {
//                strongSelf.rx_checked.value = !strongSelf.rx_checked.value
//            }
//        }
        
        rx_checked.asObservable().distinctUntilChanged().subscribe(onNext: { [weak self] (_) -> Void in
            self?.refreshCheckImageView()
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
    
    @objc private func toogleCheckedValue(){
        rx_checked.value = !rx_checked.value
    }

    private func refreshCheckImageView() {
        checkImageView.image = rx_checked.value ? checkedImage : uncheckedImage
    }


}
