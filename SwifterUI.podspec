
Pod::Spec.new do |s|

  s.name         = "SwifterUI"
  s.version      = "0.3"
  s.summary      = "swift 快速开发框架"
  s.license      = 'MIT'
  s.author       = { "ukeem" => "1944486008@qq.com" }
  s.ios.deployment_target     = '10.0'

  s.requires_arc = true
  s.homepage     = "https://github.com/zytabcd123/SwifterUI"
  s.source       = { :git => "https://github.com/zytabcd123/SwifterUI.git", :tag => s.version }

  s.swift_version = '5.0'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'SnapKit'
  s.dependency 'SDWebImage'
  s.public_header_files = 'SwifterUI/SB/HUD/**/*.h'
  s.resources = ['SwifterUI/SB/Photo/**/*.{png,storyboard}']
  s.source_files = 'SwifterUI/SB/Kit/**/*.swift',
                   'SwifterUI/SB/Foundation/**/*.swift',
                   'SwifterUI/SB/Rx/**/*.swift',
                   'SwifterUI/SB/Tools/**/*.swift',
                   'SwifterUI/SB/Base/**/*.swift',
                   'SwifterUI/SB/Widget/**/*.swift',
                   'SwifterUI/SB/Bridging-Header.h',
                   'SwifterUI/SB/Photo/**/*.swift',
                   'SwifterUI/SB/Json/**/*.swift',
                   'SwifterUI/SB/Banner/**/*.swift',
                   'SwifterUI/SB/Refresh/**/*.swift',
                   'SwifterUI/SB/HUD/**/*.{h,m,swift}'


end
