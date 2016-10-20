Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "JeraUtils"
  s.summary = "Basic Tools for App Development in Jera"
  s.requires_arc = true

  s.version = "0.4.0"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "Alessandro Nakamuta" => "warthog@jera.com.br" }

  s.homepage = "https://github.com/aleufms/JeraUtils"

  s.source = { :git => "https://github.com/aleufms/JeraUtils.git", :tag => "#{s.version}"}

  s.framework = "UIKit"

  #Swift
  s.dependency 'Cartography', '= 0.7.0'
  s.dependency 'Kingfisher', '= 2.6.1'
  s.dependency 'ReachabilitySwift', '= 2.4'
  s.dependency 'TZStackView', '= 1.2.0'

  s.dependency 'Material'
  s.dependency 'ChameleonFramework/Swift'
  s.dependency 'FontAwesome.swift'
  s.dependency 'Moya-ObjectMapper/RxSwift'
  s.dependency 'RxCocoa'

  #Adicione essas linhas Podfile do seu projeto
  #Podfile Swift 2.3
  # pod 'Material', :git => 'https://github.com/CosmicMind/Material', :branch => 'swift-2.3'
  # pod 'ChameleonFramework', :git => 'https://github.com/ViccAlexander/Chameleon', :tag => '2.1.0'
  # pod 'FontAwesome.swift', :git => 'https://github.com/thii/FontAwesome.swift', :tag => '0.10.1'

  # pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/ivanbruel/Moya-ObjectMapper',:tag => '1.4'
  # pod 'Moya', :git => 'https://github.com/Moya/Moya', :tag => '7.0.3'
  # pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift', :tag => '2.6.0'
  # pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift', :tag => '2.6.0'

  #e no final
  # post_install do |installer|

  #   installer.pods_project.targets.each do |target|

  #       target.build_configurations.each do |configuration|

  #           configuration.build_settings['SWIFT_VERSION'] = "2.3"

  #       end

  #   end

  # end

  #Obj-C
  s.dependency 'HMSegmentedControl', '~> 1.5'
  s.dependency 'INSPullToRefresh', '~> 1.1'
  s.dependency 'MMDrawerController', '~> 0.6'
  s.dependency 'NSStringMask', '~> 1.2'
  s.dependency 'SpinKit', '~> 1.2'
  s.dependency 'TPKeyboardAvoiding', '~> 1.3'

  s.source_files = "JeraUtils/**/*.{swift}"

#  s.resources = "JeraUtils/**/*.{storyboard,xcassets,otf,ttf}"
  s.resource_bundles = { 'JeraUtils' => ['JeraUtils/**/*.{xib,storyboard,xcassets,otf,ttf}'] }

end
