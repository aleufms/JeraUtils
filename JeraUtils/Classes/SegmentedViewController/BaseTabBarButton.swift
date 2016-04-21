//
//  BaseTabBarView.swift
//  Ativoapp
//
//  Created by Alessandro Nakamuta on 11/11/15.
//  Copyright © 2015 Ativo. All rights reserved.
//

import UIKit

class BaseTabBarButton: UIView {

    var selected = false {
        didSet {
            refreshSelected()
        }
    }

    func refreshSelected() {
        //must override
    }

}
