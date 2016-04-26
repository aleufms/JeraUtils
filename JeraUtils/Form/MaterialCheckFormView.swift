//
//  MaterialCheckFormView.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/17/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import MK
import FontAwesome_swift
import Tactile
import RxSwift

public class MaterialCheckFormView: UIView {

    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!

    let disposeBag = DisposeBag()
    let rx_checked = Variable(false)

    public var checkedImage = UIImage.fontAwesomeIconWithName(FontAwesome.CheckSquareO, textColor: UIColor(red: 238/255, green: 47/255, blue: 125/255, alpha: 1), size: CGSize(width: 36, height: 36)) {
        didSet {
            refreshCheckImageView()
        }
    }

    public var uncheckedImage = UIImage.fontAwesomeIconWithName(FontAwesome.SquareO, textColor: UIColor(red: 238/255, green: 47/255, blue: 125/255, alpha: 1), size: CGSize(width: 36, height: 36)) {
        didSet {
            refreshCheckImageView()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        refreshCheckImageView()

        self.tap { [weak self] (_) -> Void in
            if let strongSelf = self {
                strongSelf.rx_checked.value = !strongSelf.rx_checked.value
            }
        }

        rx_checked.asObservable().distinctUntilChanged().subscribeNext { [weak self] (_) -> Void in
            self?.refreshCheckImageView()
        }.addDisposableTo(disposeBag)
    }

    private func refreshCheckImageView() {
        checkImageView.image = rx_checked.value ? checkedImage : uncheckedImage
    }


}
