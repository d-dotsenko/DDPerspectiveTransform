Pod::Spec.new do |spec|

	spec.name 		= "DDPerspectiveTransform"
	spec.platform 		= :ios
	spec.summary 		= "DDPerspectiveTransform lets a user do warp image transformation"
	spec.requires_arc 	= true
	spec.version 		= "1.0.2"
	spec.license 		= { :type => "MIT", :file => "LICENSE" }	
	spec.author 		= { "Dmitriy Dotsenko" => "d.dotsenko@icloud.com" }
	spec.homepage 		= "https://github.com/d-dotsenko/DDPerspectiveTransform"
	spec.source 		= { :git => "https://github.com/d-dotsenko/DDPerspectiveTransform.git", :tag => "#{spec.version}" }
	spec.frameworks 	= "UIKit"
	spec.source_files 	= "DDPerspectiveTransform/**/*.{h,swift}"
	spec.swift_version 	= "4.2"
	spec.ios.deployment_target 	= "8.2"
end
