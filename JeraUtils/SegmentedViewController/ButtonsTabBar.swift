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

public protocol ButtonsTabBarDelegate: class {
    func pressedIndex(index: Int)
}

public class ButtonsTabBar: UIView {

    public weak var delegate: ButtonsTabBarDelegate?

    public var selectedIndex: Int? {
        didSet {
            refreshTabBarButtons()
        }
    }

    private lazy var stackView: TZStackView = {
        let stackView = TZStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
//        stackView.alignment = .Center
        stackView.backgroundColor = UIColor.clear
        return stackView
    }()

    public init() {
        super.init(frame: CGRect.zero)
        setupSubviews()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
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
                for (index, tabBarButton) in tabBarButtons.enumerated() {
                    stackView.addArrangedSubview(viewForTabBarButton(tabBarButton: tabBarButton, tag: index))
                }
            }

            refreshTabBarButtons()
        }
    }

    public func populateWith(tabBarButtons: [BaseTabBarButton]) {
        self.tabBarButtons = tabBarButtons
    }

    private func viewForTabBarButton(tabBarButton: BaseTabBarButton, tag: Int) -> UIView {
        let tapButton = UIButton(type: .custom)
        tapButton.tag = tag
        tapButton.addTarget(self, action: #selector(ButtonsTabBar.tabButtonAction), for: .touchUpInside)

        let contentView = UIView()

        contentView.addSubview(tapButton)
        constrain(contentView, tapButton) { (contentView, tapButton) -> () in
            tapButton.edges == contentView.edges
        }

        tabBarButton.isUserInteractionEnabled = false
        contentView.addSubview(tabBarButton)
        constrain(contentView, tabBarButton) { (contentView, tabBarButton) -> () in
            tabBarButton.edges == contentView.edges
        }

        return contentView
    }

    public func tabButtonAction(button: UIButton) {
        selectedIndex = button.tag

        if let delegate = delegate, let selectedIndex = selectedIndex {
            delegate.pressedIndex(index: selectedIndex)
        }
    }

    public func refreshTabBarButtons() {
        if let tabBarButtons = tabBarButtons {
            for (index, tabBarButton) in tabBarButtons.enumerated() {
                tabBarButton.selected = index == selectedIndex
            }
        }
    }

}
