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
    
    public var urlToGo: URL? {
        didSet{
            goToUrlToGo()
        }
    }
    
    private func goToUrlToGo(){
        if let urlToGo = urlToGo {
            webView.load(URLRequest(url: urlToGo))
        }
    }
    
    public var fileUrlToGo: URL? {
        didSet{
            goToFileUrlToGo()
        }
    }
    
    private func goToFileUrlToGo(){
        if let fileUrlToGo = fileUrlToGo{
            if #available(iOS 9.0, *) {
                // iOS9 and above. One year later things are OK.
                webView.loadFileURL(fileUrlToGo, allowingReadAccessTo: fileUrlToGo)
            } else {
                // iOS8. Things can (sometimes) be workaround-ed
                //   Brave people can do just this
                //   fileURL = try! pathForBuggyWKWebView8(fileURL: fileURL)
                //   webView.load(URLRequest(url: fileURL))
                do {
                    let fileURL = try fileURLForBuggyWKWebView8(fileURL: fileUrlToGo)
                    webView.load(URLRequest(url: fileURL))
                } catch let error as NSError {
                    print("Error: " + error.debugDescription)
                }
            }
        }
    }
    
    public var linkAction = JeraWebViewLinkAction.Default
    
    public lazy var webView: JeraWebView = {
        let webView = JeraWebView()
        webView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self
        return webView
    }()
    
    fileprivate var disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //        screenName = "WebView"
        
        view.addSubview(webView)
        constrain(view, webView, block: { (view, webView) -> () in
            webView.edges == view.edges
        })
        
        if let urlToGo = urlToGo {
            goToUrlToGo()
        }else if let fileUrlToGo = fileUrlToGo{
            goToFileUrlToGo()
        }
    }
    
    public func addShareButton(imageName imageName: String) {
        let shareBarButton = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: nil, action: nil)
        
        shareBarButton.rx.tap.subscribe(onNext: { [weak self] () -> Void in
            if let strongSelf = self {
                if let contentURL = strongSelf.webView.url {
                    Helper.shareAction(url: contentURL as NSURL?, topViewController: strongSelf)
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        navigationItem.rightBarButtonItem = shareBarButton
    }
    
    //https://stackoverflow.com/questions/24882834/wkwebview-not-loading-local-files-under-ios-8
    private func fileURLForBuggyWKWebView8(fileURL: URL) throws -> URL {
        // Some safety checks
        if !fileURL.isFileURL {
            throw NSError(
                domain: "BuggyWKWebViewDomain",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("URL must be a file URL.", comment:"")])
        }
        try! fileURL.checkResourceIsReachable()
        
        // Create "/temp/www" directory
        let fm = FileManager.default
        let tmpDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("www")
        try! fm.createDirectory(at: tmpDirURL, withIntermediateDirectories: true, attributes: nil)
        
        // Now copy given file to the temp directory
        let dstURL = tmpDirURL.appendingPathComponent(fileURL.lastPathComponent)
        let _ = try? fm.removeItem(at: dstURL)
        try! fm.copyItem(at: fileURL, to: dstURL)
        
        // Files in "/temp/www" load flawlesly :)
        return dstURL
    }
}

extension JeraWebViewController: WKNavigationDelegate {
    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        AlertManager.sharedManager.error(errorType: error, presenterViewController: self).subscribe(onNext: { [weak self] (option) in
            if let strongSelf = self {
                switch option {
                case .Retry:
                    if let urlToGo = self?.urlToGo {
                        strongSelf.webView.load(NSURLRequest(url: urlToGo as URL) as URLRequest)
                    }
                case .Cancel:
                    strongSelf.close()
                default:
                    break
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
    
    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated{
            switch linkAction {
            case .Default:
                decisionHandler(.allow)
            case .Modal:
                if let url = navigationAction.request.url{
                    let modalWebViewController = JeraWebViewController()
                    modalWebViewController.urlToGo = url
                    
                    let navigationController = JeraBaseNavigationController(rootViewController: modalWebViewController)
                    
                    modalWebViewController.addCloseButton()
                    
                    present(navigationController, animated: true, completion: nil)
                }
                decisionHandler(.cancel)
            case .Safari:
                if let url = navigationAction.request.url{
                    UIApplication.shared.openURL(url)
                }
                decisionHandler(.cancel)
            }
        }else{
            decisionHandler(.allow)
        }
        
        
        
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
}

extension Helper {
    public class func showWebViewWithURL(url: URL?, title: String? = nil, showShareButton: Bool = false, shareButtonImageName: String = "", presenterViewController: UIViewController) {
        let jeraWebViewController = JeraWebViewController()
        jeraWebViewController.urlToGo = url
        
        if let title = title {
            jeraWebViewController.title = title
        }
        
        jeraWebViewController.addCloseButton()
        
        if showShareButton || !shareButtonImageName.isEmpty {
            jeraWebViewController.addShareButton(imageName: shareButtonImageName)
        }
        
        let navigationController = JeraBaseNavigationController(rootViewController: jeraWebViewController)
        presenterViewController.present(navigationController, animated: true, completion: nil)
    }
    
    public class func showWebViewWithURL(fileUrl: URL?, title: String? = nil, showShareButton: Bool = false, shareButtonImageName: String = "", presenterViewController: UIViewController) {
        let jeraWebViewController = JeraWebViewController()
        jeraWebViewController.fileUrlToGo = fileUrl
        
        if let title = title {
            jeraWebViewController.title = title
        }
        
        jeraWebViewController.addCloseButton()
        
        if showShareButton || !shareButtonImageName.isEmpty {
            jeraWebViewController.addShareButton(imageName: shareButtonImageName)
        }
        
        let navigationController = JeraBaseNavigationController(rootViewController: jeraWebViewController)
        presenterViewController.present(navigationController, animated: true, completion: nil)
    }
}
