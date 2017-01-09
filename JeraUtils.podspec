Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '9.0'
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
  s.dependency 'Cartography', '~> 1.0'
  s.dependency 'Kingfisher', '~> 3.2'
  s.dependency 'Material', '~> 2.4'
  s.dependency 'ReachabilitySwift', '~> 3'
  s.dependency 'TZStackView', '~> 1.3' 
  s.dependency 'RxSwift', '~> 3.1'
  s.dependency 'RxCocoa', '~> 3.1'
  s.dependency 'Moya-ObjectMapper', '~> 2.3'
  s.dependency 'FontAwesome.swift', '~> 1.0'

  # s.dependency 'ChameleonFramework', '~> 2.2'

  #Adicione essas linhas Podfile do seu projeto
  #Podfile Swift 3.0
  # pod 'ChameleonFramework', :git => 'https://github.com/ViccAlexander/Chameleon', :tag => '2.2.0'

  #e no final
  # post_install do |installer|

  #   installer.pods_project.targets.each do |target|

  #       target.build_configurations.each do |configuration|

  #           configuration.build_settings['SWIFT_VERSION'] = "3.0"

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
