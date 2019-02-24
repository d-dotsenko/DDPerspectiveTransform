#
#  Be sure to run `pod spec lint DDPerspectiveTransform.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.platform = :ios
  spec.name             = "DDPerspectiveTransform"
  spec.version          = "0.0.1"
  spec.summary          = "Warp image transformation"
  spec.homepage         = "https://github.com/d-dotsenko/DDPerspectiveTransform"
  spec.license          = "MIT"
  spec.author           = "Dmitriy Dotsenko"
  spec.source           = { :git => "https://github.com/d-dotsenko/DDPerspectiveTransform.git",
                            :tag => "#{spec.version}" }
  spec.source_files     = "DDPerspectiveTransform/**/*.{h,swift}"
  spec.frameworks       = "UIKit"
  spec.swift_version    = "4.2"

end
