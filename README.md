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



Documentation on how to use this pod is going to be written soon.

## Bug Reporting

Any bug can be reported as a pull request in our git repository or e-mailed to warthog@jera.com.br or magpali@jera.com.br

## Credits

JeraUtils is owned and maintained by [Jera](http://jera.com.br). You can follow us on Twitter at [@jerasoftware](https://twitter.com/jerasoftware) and on Facebook at [Jera](https://www.facebook.com/jerasoftware).

## License

JeraUtils is released under the MIT license. See LICENSE for details.
