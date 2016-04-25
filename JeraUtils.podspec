Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "JeraUtils"
  s.summary = "Basic Tools for App Development in Jera"
  s.requires_arc = true
 
  s.version = "0.1.0"
 
  s.license = { :type => "MIT", :file => "LICENSE" }
 
  s.author = { "Alessandro Nakamuta" => "warthog@jera.com.br" }
 
  s.homepage = "https://github.com/aleufms/JeraUtils"
 
  s.source = { :git => "https://github.com/aleufms/JeraUtils.git", :tag => "#{s.version}"}
 
  s.framework = "UIKit"
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
 
  s.source_files = "JeraUtils/**/*.{swift}"
 
  s.resources = "JeraUtils/Assets.xcassets/**/*.{png,jpeg,jpg,storyboard,xib}"
end