//
//  JeraWebView.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 11/11/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import WebKit

import Cartography
import RxSwift

public class JeraWebView: WKWebView {

    public lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .Default)
//        progressView.tintColor = Colors.secondaryColors
        return progressView
    }()

    private var disposeBag = DisposeBag()

    public init() {
        let configuration = WKWebViewConfiguration()
        super.init(frame: CGRect.zero, configuration: configuration)

        addProgressView()

        addObservers()
    }

    public init(withConfiguration configuration: WKWebViewConfiguration) {
        super.init(frame: CGRect.zero, configuration: configuration)

        addProgressView()

        addObservers()
    }

    
    private func addProgressView() {
        self.addSubview(progressView)

        constrain(self, progressView) { (webView, progressView) -> () in
            progressView.top == webView.top
            progressView.left == webView.left
            progressView.right == webView.right
        }
    }

    public func addObservers() {
        let estimatedProgressObserver = self.rx_observe(Double.self, "estimatedProgress")
            .shareReplay(1)

        estimatedProgressObserver
            .map { (estimatedProgress) -> Float in
                return Float(estimatedProgress ?? 0)
            }.bindTo(progressView.rx_progress)
            .addDisposableTo(disposeBag)

        estimatedProgressObserver
            .map { (estimatedProgress) -> Bool in
                return estimatedProgress == 1
            }.bindTo(progressView.rx_hidden)
            .addDisposableTo(disposeBag)
    }
}

public extension UIProgressView {

    /**
     Bindable sink for `progress` property.
     */
    public var rx_progress: AnyObserver<Float> {
        return AnyObserver { [weak self] event in
            MainScheduler.ensureExecutingOnScheduler()

            switch event {
            case .Next(let value):
                self?.progress = value
            case .Error(let error):
                print(error)
                break
            case .Completed:
                break
            }
        }
    }
}
