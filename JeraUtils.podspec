#
# Be sure to run `pod lib lint JeraUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JeraUtils"
  s.version          = "0.1.0"
  s.summary          = "Basic Tools for App Development in Jera"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "This set of tools were developed within Jera to speed the process of iOS App development"

  s.homepage         = "https://github.com/aleufms/JeraUtils"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Victor Magpali" => "victormagpali@gmail.com" }
  s.source           = { :git => "https://github.com/aleufms/JeraUtils.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JeraUtils/Classes/**/*'
  s.resource_bundles = {
    'JeraUtils' => ['JeraUtils/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  Pod::Spec.new do |s|
    #Swift
    s.dependency 'Cartography', '~> 0.6'
    s.dependency 'ChameleonFramework/Swift', '~> 2.1'
    #s.dependency 'Eureka', '~> 1.5'
    s.dependency 'FontAwesome.swift', '~> 0.7'
    s.dependency 'MK', '~> 1.27'
    s.dependency 'Moya-ObjectMapper/RxSwift', '~> 1.2'
    s.dependency 'ReachabilitySwift', '~> 2.3'
    s.dependency 'RxCocoa', '~> 2.4'
    s.dependency 'Tactile', '~> 1.2'
    s.dependency 'TZStackView', '~> 1.1'
    #Obj-C
    s.dependency 'Google/Analytics', '~> 2.0'
    s.dependency 'HMSegmentedControl', '~> 1.5'
    s.dependency 'INSPullToRefresh', '~> 1.1'
    s.dependency 'MMDrawerController', '~> 0.6'
    s.dependency 'NSStringMask', :git => 'https://github.com/aleufms/NSStringMask', :commit => '13f13ce1eeb74985ea07f2950eb5925dc7f231c8'  #Remove warnings and bullshits
    s.dependency 'SDWebImage', '~> 3.7'
    s.dependency 'SpinKit', '~> 1.2'
    s.dependency 'TPKeyboardAvoiding', '~> 1.3'
  end
end
