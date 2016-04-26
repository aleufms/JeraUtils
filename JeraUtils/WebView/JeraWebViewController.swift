//
//  JeraWebViewController.swift
//  Jera
//
//  Created by Alessandro Nakamuta on 11/4/15.
//  Copyright © 2015 Jera. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import WebKit

public enum JeraWebViewLinkAction{
    case Default
    case Modal
    case Safari
}

public class JeraWebViewController: JeraBaseViewController {

    public var urlToGo: NSURL? {
        didSet{
            if let urlToGo = urlToGo {
                webView.loadRequest(NSURLRequest(URL: urlToGo))
            }
        }
    }
    
    public var linkAction = JeraWebViewLinkAction.Default

    public lazy var webView: JeraWebView = {
        let webView = JeraWebView()
        webView.backgroundColor = UIColor.clearColor()
        webView.navigationDelegate = self
        return webView
    }()

    private var disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()

//        screenName = "WebView"

        view.addSubview(webView)
        constrain(view, webView, block: { (view, webView) -> () in
            webView.edges == view.edges
        })

        if let urlToGo = urlToGo {
            webView.loadRequest(NSURLRequest(URL: urlToGo))
        }
    }

    public func addShareButton(imageName imageName: String) {
        let shareBarButton = UIBarButtonItem(image: UIImage(named: imageName), style: .Plain, target: nil, action: nil)

        shareBarButton.rx_tap.subscribeNext { [weak self] () -> Void in
            if let strongSelf = self {
                if let contentURL = strongSelf.webView.URL {
                    Helper.shareAction(url: contentURL, topViewController: strongSelf)
                }
            }
        }.addDisposableTo(disposeBag)

        navigationItem.rightBarButtonItem = shareBarButton
    }
}

extension JeraWebViewController: WKNavigationDelegate {
    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        AlertManager.sharedManager.error(error, presenterViewController: self)
            .subscribeNext { [weak self] (option) -> Void in
            if let strongSelf = self {
                switch option {
                case .Retry:
                    if let urlToGo = self?.urlToGo {
                        strongSelf.webView.loadRequest(NSURLRequest(URL: urlToGo))
                    }
                case .Cancel:
                    strongSelf.close()
                default:
                    break
                }
            }
        }.addDisposableTo(disposeBag)
    }
    
    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .LinkActivated{
            switch linkAction {
            case .Default:
                decisionHandler(.Allow)
            case .Modal:
                if let url = navigationAction.request.URL{
                    let modalWebViewController = JeraWebViewController()
                    modalWebViewController.urlToGo = url
                    
                    let navigationController = JeraBaseNavigationController(rootViewController: modalWebViewController)
                    
                    modalWebViewController.addCloseButton()
                    
                    presentViewController(navigationController, animated: true, completion: nil)
                }
                decisionHandler(.Cancel)
            case .Safari:
                if let url = navigationAction.request.URL{
                    UIApplication.sharedApplication().openURL(url)
                }
                decisionHandler(.Cancel)
            }
        }else{
            decisionHandler(.Allow)
        }
        
        
        
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
}

extension Helper {
    public class func showWebViewWithURL(url: NSURL?, title: String? = nil, showShareButton: Bool = false, shareButtonImageName: String = "", presenterViewController: UIViewController) {
        let jeraWebViewController = JeraWebViewController()
        jeraWebViewController.urlToGo = url

        if let title = title {
            jeraWebViewController.navigationItem.title = title
        }

        jeraWebViewController.addCloseButton()

        if showShareButton || !shareButtonImageName.isEmpty {
            jeraWebViewController.addShareButton(imageName: shareButtonImageName)
        }

        let navigationController = JeraBaseNavigationController(rootViewController: jeraWebViewController)
        presenterViewController.presentViewController(navigationController, animated: true, completion: nil)
    }
}
