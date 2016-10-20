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
        let podBundle = NSBundle(forClass: self)
        if let bundleURL = podBundle.URLForResource("JeraUtils", withExtension: "bundle") {
            if let bundle = NSBundle(URL: bundleURL) {
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

    public var checkedImage = UIImage.fontAwesomeIconWithName(FontAwesome.CheckSquareO, textColor: UIColor.grayColor(), size: CGSize(width: 36, height: 36)).imageWithRenderingMode(.AlwaysTemplate) {
        didSet {
            refreshCheckImageView()
        }
    }

    public var uncheckedImage = UIImage.fontAwesomeIconWithName(FontAwesome.SquareO, textColor: UIColor.grayColor(), size: CGSize(width: 36, height: 36)).imageWithRenderingMode(.AlwaysTemplate) {
        didSet {
            refreshCheckImageView()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        refreshCheckImageView()
        
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MaterialCheckFormView.toogleCheckedValue)))

//        self.tap { [weak self] (_) -> Void in
//            if let strongSelf = self {
//                strongSelf.rx_checked.value = !strongSelf.rx_checked.value
//            }
//        }

        rx_checked.asObservable().distinctUntilChanged().subscribeNext { [weak self] (_) -> Void in
            self?.refreshCheckImageView()
        }.addDisposableTo(disposeBag)
    }
    
    @objc private func toogleCheckedValue(){
        rx_checked.value = !rx_checked.value
    }

    private func refreshCheckImageView() {
        checkImageView.image = rx_checked.value ? checkedImage : uncheckedImage
    }


}
