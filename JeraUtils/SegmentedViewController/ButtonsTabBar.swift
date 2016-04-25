//
//  JeraTabBar.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 11/11/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import TZStackView
import Cartography
//import MaterialKit

protocol ButtonsTabBarDelegate: class {
    func pressedIndex(index: Int)
}

class ButtonsTabBar: UIView {

    weak var delegate: ButtonsTabBarDelegate?

    var selectedIndex: Int? {
        didSet {
            refreshTabBarButtons()
        }
    }

    private lazy var stackView: TZStackView = {
        let stackView = TZStackView()
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
//        stackView.alignment = .Center
        stackView.backgroundColor = UIColor.clearColor()
        return stackView
    }()

    init() {
        super.init(frame: CGRect.zero)
        setupSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    private func setupSubviews() {
        addStackView()
    }

    private func addStackView() {
        addSubview(stackView)
        constrain(self, stackView) { (view, stackView) -> () in
            stackView.edges == view.edges
        }
    }

    private(set) var tabBarButtons: [BaseTabBarButton]? {
        didSet {
            stackView.removeAllArrangedSubviews()

            if let tabBarButtons = tabBarButtons {
                for (index, tabBarButton) in tabBarButtons.enumerate() {
                    stackView.addArrangedSubview(viewForTabBarButton(tabBarButton, tag: index))
                }
            }

            refreshTabBarButtons()
        }
    }

    func populateWith(tabBarButtons: [BaseTabBarButton]) {
        self.tabBarButtons = tabBarButtons
    }

    private func viewForTabBarButton(tabBarButton: BaseTabBarButton, tag: Int) -> UIView {
        let tapButton = UIButton(type: .Custom)
        tapButton.tag = tag
        tapButton.addTarget(self, action: #selector(ButtonsTabBar.tabButtonAction), forControlEvents: .TouchUpInside)

        let contentView = UIView()

        contentView.addSubview(tapButton)
        constrain(contentView, tapButton) { (contentView, tapButton) -> () in
            tapButton.edges == contentView.edges
        }

        tabBarButton.userInteractionEnabled = false
        contentView.addSubview(tabBarButton)
        constrain(contentView, tabBarButton) { (contentView, tabBarButton) -> () in
            tabBarButton.edges == contentView.edges
        }

        return contentView
    }

    func tabButtonAction(button: UIButton) {
        selectedIndex = button.tag

        if let delegate = delegate, selectedIndex = selectedIndex {
            delegate.pressedIndex(selectedIndex)
        }
    }

    func refreshTabBarButtons() {
        if let tabBarButtons = tabBarButtons {
            for (index, tabBarButton) in tabBarButtons.enumerate() {
                tabBarButton.selected = index == selectedIndex
            }
        }
    }

}
