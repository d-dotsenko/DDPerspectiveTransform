Pod::Spec.new do |spec|

	spec.name 		= "DDPerspectiveTransform"
	spec.platform 		= :ios
	spec.summary 		= "DDPerspectiveTransform allows a user to make warp image transformation"
	spec.requires_arc 	= true
	spec.version 		= "1.1.3"
	spec.license 		= { :type => "MIT", :file => "LICENSE" }	
	spec.author 		= { "Dmitriy Dotsenko" => "d.dotsenko@icloud.com" }
	spec.homepage 		= "https://github.com/d-dotsenko/DDPerspectiveTransform"
	spec.source 		= { :git => "https://github.com/d-dotsenko/DDPerspectiveTransform.git", :tag => "#{spec.version}" }
	spec.frameworks 	= "UIKit"
	spec.source_files 	= "DDPerspectiveTransform/**/*.{h,swift}"
	spec.swift_version 	= "4.2"
	spec.ios.deployment_target 	= "9.0"
end
