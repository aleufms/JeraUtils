![Jera Utils: The Basic Toolset](http://jera.com.br/images/logo-jera-header@3x.png)

# JeraUtils
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JeraUtils.svg)](https://img.shields.io/cocoapods/v/JeraUtils.svg)
[![Platform](https://img.shields.io/cocoapods/p/JeraUtils.svg)](https://img.shields.io/cocoapods/p/JeraUtils.svg)
[![License](https://img.shields.io/cocoapods/l/JeraUtils.svg)](https://img.shields.io/cocoapods/l/JeraUtils.svg)

Jera Utils is a pod with all the basic tools we use in most of the apps we build.

It is still under development and being tested as a pod so if you are not a member of Jera's team use it at your own risk.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
> CocoaPods 0.39.0+ is recommended.

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'JeraUtils', '~> 0.2.2'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

First, import JeraUtils into your class

```swift
import JeraUtils
```

###BaseViewController
In order the use this class and it's methods your controller must extend from JeraBaseViewController
We recommend creating your own Base V.C. extending from JeraUtil's so you can adapt it to your project. 

```swift
class BaseViewController: JeraBaseViewController { }
```

#####Subviews
The BaseViewController has the following subviews by default:
[ scrollView, tableView, collectionView, stackView ] which a created on Insets (0,0,0,0)
If you want to use a tableView in you controller you need just populate it as the variable deal with it being null or not and then returns the view you were using.
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorStyle = .None
    tableView.registerNib(R.nib.aboutHeaderCell)    
    tableView.dataSource = self
    tableView.delegate = self
}
```
> Note that the delegate for the view you intend to use MUST be implemented by your Controller.

####Methods
###### addCloseButton()
Adds the close option to the navigation controller which calls the close function when tapped
```swift
self.addCloseButton()
```	
###### close()
Dismisses the viewController when opened as a modal, otherwise it pops it away.
```swift
self.close()
```	
###### isModal()
Returns whether the controller was opened as a Modal or not.
```swift
if self.isModal() {
	print("This ViewController is opened as a Modal")
}
```	
##### listenKeyboard()
Listends to when the keyboard is going to show or hide and ajusts your view accordingly
```swift
self.listenKeyboard()
```	

###Alerts
The AlertManager has a sharedManager static variable which must be used to invoque it's methods.

###### alert(title: String?, message: String?, alertOptions: [AlertOption]?, hasCancel: Bool, preferredStyle: UIAlertControllerStyle, presenterViewController: UIViewController)
Creates an alert and shows it on your screen.
- parameter title: The title that will be shown on the top of the alert view.
- parameter message: The message to be displayed inside the alert view box.
- parameter allertOptions: An array of AlertOption which are composed of a title and a style.
- parameter hasCancle: Boolean indicating whether there will be a cancel option.
- parameter preferredStyle: The style the AlertController is going the be.
- parameter presenterViewController: The controller which is going to present the alert.
- retuns: Observable AlertManagerOption
```swift
AlertManager.sharedManager.alert(title: "WARNING", message: "Execute order 66", options: ["OK"], hasCancel: true, preferredStyle: .Alert, presenterViewController: self).subscribeNext({ [weak self]  (option) -> Void in
    if let strongSelf = self {
        switch option {
        case .Button:
        	self.executeOrder66()
        default:
        	self.cancelOrder66()
        }
    }
}).addDisposableTo(disposeBag)
```

#### error(errorType: ErrorType, preferredStyle: UIAlertControllerStyle, presenterViewController: UIViewController)
Creates an error alert and shows it on your screen.
- parameter errorType: The type of the error you want the alert the user of.
- parameter preferredStyle: The style the AlertController is going the be.
- parameter presenterViewController: The controller which is going to present the error alert.
- retuns: Observable AlertManagerOption
```swift
AlertManager.sharedManager.error(error, presenterViewController: self).subscribeNext({ [weak self]  (option) -> Void in
	if let strongSelf = self {
	    switch option {
	    case .Retry:
	        strongSelf.retry()
	    default:
	        break
	    }
	}
}).addDisposableTo(strongSelf.alertDisposeBag)
```

###WebViews
A WKWebview extension with a progressbar on the top.
It's variable 'progress' can receive a tint color
```swift
let webView = JeraWebView()
webView.progressView.tintColor = UIColor.redColor()
```

###PullToRefresh
The PullToRefresh class is a ScrollView helper which has the following two methods.

#### addPullToRefreshToScrollView(scrollView: UIScrollView, handler: (UIScrollView!) -> Void)
Adds pullToRefresh capabilities to your ScrollView.
- parameter scrollView: The scrollView in which you want to add PullToRefresh capabilities to.
- parameter handler: The block of code to be executed whenever there's a pull to refresh action.
```swift
PullToRefreshHelper.addPullToRefreshToScrollView(myTableView) { [weak self]  (myTableView) -> Void in
    self?.refreshMyTableView()
}
```

#### addInfinityScrollRefreshView(scrollView: UIScrollView, handler: (UIScrollView!) -> Void)
Adds pagination capabilities to your ScrollView.
- parameter scrollView: The scrollView in which you want to add pagination capabilities to.
- parameter handler: The block of code to be executed whenever there's a pull to refresh action.
```swift
PullToRefreshHelper.addInfinityScrollRefreshView(myTableView) { [weak self]  (myTableView) -> Void in
    self?.loadNextPage()
}
```
### HudManager
#### showCustomView(customView: UIView, dismissAfter: Double, userInteractionEnabled: Bool, customLayout: ((containerView: UIView, customView: UIView) -> ())? = nil)
Shows a custom view popup
- parameter customView: The view to be shown. If other Huds are already being shown this view will be shown after the others are dismissed
- parameter dismissAfter: Seconds before the view is dismissed. If nil the dismissing should be handled by your code.
- parameter userInteractionEnabled: Whether the user can interact with the view or not. Set true by default.
- parameter customLayout: A block with a custom container view and a custom view with their constrains and layout alreay set. By default it will layout in the middle of the screen.
```swift
HudManager.showCustomView(myCustomView)
```

#### dismissHudView(hudView: UIView)
Dismiss a view being or about to be shown by the HUDManager
- parameter hudView: The view to be dismissed
```swift
HudManager.dismissHudView(myCustomView)
```

#### func showToastWithText(text: String, dismissAfter: Double) -> HudToast
Shows a text HudView as a toast.
- parameter text: The text to be shown in the toast view.
- parameter dismissAfter: Duration of the toast in seconds. Default duration is 3.5sec.
- returns: Returns the toast view.
```swift
HudManager.showToastWithText(text: "Execute order 66", dismissAfter: 10)
```

### Messages
#### showLoadingText(text: String, color: UIColor, type: LoadingViewType, contentView: UIView, messagePosition: BaseViewControllerMessagePosition, contentBlocked: Bool)
Shows an animated loading message.
- parameter text:            The text to be shown in the loading message
- parameter color:           The color of the text to be shown
- parameter type:            The type of the loadingView. Receives a LoadingViewType, which can be an animated compass or a RTSpinKitViewStyle. The LoadingViewType is set to RTSpinKitViewStyle.StyleThreeBounce by default.
- parameter contentView:     The view which will show the loading message. The message will be shown in the view of the ViewController who invoqued it by default.
- parameter messagePosition: A position used to layout the loading message. It will layout it in the middle of the view by default.
- parameter contentBlocked:  A boolean to whether the loading message will block user interaction or not. It is set to false by default.
```swift
myViewController.showLoadingText("Loading position...", type: .Compass)
```

#### showMessageText(text: String, color: UIColor, messageType: MessageViewType, contentView: UIView, messagePosition: BaseViewControllerMessagePosition, contentBlocked: Bool, reloadBlock: (()->Void))
Shows a message in the view. It's main purpose is to show connection problems messages. The message will usually contain a try again button.
- parameter text: The text to be shown as a message
- parameter color: The color of the text to be shown
- parameter messageType: The type of the message. For detailed description check MessageViewType enum.
- parameter contentView: The view which will show the message. The message will be shown in the view of the ViewController who invoked it by default.
- parameter messagePosition: A position used to layout the loading message. It will layout it in the middle of the view by default.
- parameter contentBlocked:  A boolean to whether the loading message will block user interaction or not. It is set to false by default.
- parameter reloadBlock: A block of code to be executed when the try again button is tapped.
```swift
myViewController.showMessageText(translateMoyaError(error).localizedDescription, messageType: .ConnectionError, reloadBlock: { [weak self]  () -> Void in
	self?.reloadMyView()
})
```

### Reachability
It's a helper to easy the process of checking connection state with Reachability

#### sharedReachability
This static variable will try to start reachability for internet connection and will log on console if unable to do so. It should be used whenever invoking a reachability method.
```swift
ReachabilityHelper.sharedReachabilty.isReachable()
```

#### reachabilityChangedObservable()
Uses reactive programming to observe any changes in the connection state.
- returns: Observable Reachability state.
```swift
ReachabilityHelper.reachabilityChangedObservable().subscribeNext { [weak self]  (reachability) -> Void in    
  switch reachability.currentReachabilityStatus {
  case .ReachableViaWiFi:
      self?.request()
  case .ReachableViaWWAN:
      break
  case .NotReachable:
      break
  }
}.addDisposableTo(disposeBag)
```


## Bug Reporting

Any bug can be reported as a pull request in our git repository or e-mailed to warthog@jera.com.br or magpali@jera.com.br

## Credits

JeraUtils is owned and maintained by [Jera](http://jera.com.br). You can follow us on Twitter at [@jerasoftware](https://twitter.com/jerasoftware) and on Facebook at [Jera](https://www.facebook.com/jerasoftware).

## License

JeraUtils is released under the MIT license. See LICENSE for details.
