# DDPerspectiveTransform

[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/cocoapods/p/DDPerspectiveTransform.svg?style=flat)](http://cocoapods.org/pods/DDPerspectiveTransform)
[![License](https://img.shields.io/cocoapods/l/DDPerspectiveTransform.svg?style=flat)](http://cocoapods.org/pods/DDPerspectiveTransform)
[![Version](https://img.shields.io/cocoapods/v/DDPerspectiveTransform.svg?style=flat)](http://cocoapods.org/pods/DDPerspectiveTransform)


Warp image transformation

<img src="Info/DDPerspectiveTransform.gif?raw=true" alt="DDPerspectiveTransform" width=320>

## Installation

### CocoaPods

To install `DDPerspectiveTransform` via [CocoaPods](http://cocoapods.org), add the following line to your Podfile:

```
pod 'DDPerspectiveTransform'
```

### Manually

Add `DDPerspectiveTransform` folder to your Xcode project.

## Usage

See the example Xcode project.

### Basic setup

Create the `DDPerspectiveTransformViewController` instance and set the `image` and `delegate` variables. Push/present it.

```swift
let cropViewController = DDPerspectiveTransformViewController() 
cropViewController.delegate = self 
cropViewController.image = image
navigationController?.pushViewController(cropViewController, animated: true)
```

### Populating the data

Implement the following `delegate` methods:

```swift
func perspectiveTransformingDidFinish(controller: DDPerspectiveTransformViewController, croppedImage: UIImage)
func perspectiveTransformingDidCancel(controller: DDPerspectiveTransformViewController)
```

### Customization

```swift
weak var delegate: DDPerspectiveTransformProtocol?
var image: UIImage? // The image for cropping
var padding: CGFloat? // Minimum padding value for all sides
var paddingWidth: CGFloat? // Minimum padding value for left and right sides
var paddingHeight: CGFloat? // Minimum padding value for top and bottom sides
var boxLineColor: UIColor? // The color of box lines
var boxLineWidth: CGFloat? // The width of box lines
var pointSize: CGSize? // The size of checkpoint
var pointColor: UIColor? // The color of checkpoint
var pointImage: UIImage? // The image of checkpoint

func cropAction()
func cancelAction()
```

## Requirements

- iOS 8.2
- Xcode 10, Swift 4.2

## License

`DDPerspectiveTransform` is available under the MIT license. See the LICENSE file for more info.
