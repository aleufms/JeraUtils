//
//  BaseTabBarView.swift
//  Ativoapp
//
//  Created by Alessandro Nakamuta on 11/11/15.
//  Copyright © 2015 Ativo. All rights reserved.
//

import UIKit

public class BaseTabBarButton: UIView {

    public var selected = false {
        didSet {
            refreshSelected()
        }
    }

    public func refreshSelected() {
        //must override
    }

}
