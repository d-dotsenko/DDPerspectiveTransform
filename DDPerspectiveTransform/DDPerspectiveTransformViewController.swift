/*
 The MIT License (MIT)
 
 Copyright (c) 2019 Dmitriy Dotsenko
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

public protocol DDPerspectiveTransformProtocol: class {
    
    /*
     Called when the image cropped
     */
    func perspectiveTransformingDidFinish(controller: DDPerspectiveTransformViewController, croppedImage: UIImage)
    
    /*
     Called when cropping is canceled
     */
    func perspectiveTransformingDidCancel(controller: DDPerspectiveTransformViewController)
}

open class DDPerspectiveTransformViewController: UIViewController {
    
    /// MARK: - Public VARs
    
    open weak var delegate: DDPerspectiveTransformProtocol?
    
    /*
     The image for cropping
     */
    open var image: UIImage? {
        set {
            guard let image = newValue else {
                return
            }
            perspectiveImageView = DDPerspectiveTransformImageView(image: image, aSuperView: view)
            if let perspectiveImageView = perspectiveImageView {
                view.addSubview(perspectiveImageView)
                view.layer.addSublayer(rectangleLayer)
            }
            reset()
        }
        get {
            return perspectiveImageView?.image
        }
    }
    
    /*
     Minimum padding value for all sides
     Default is view.frame.size.width / 8.0
     */
    open var padding: CGFloat? {
        set {
            perspectiveImageView?.padding = newValue
            reset()
        }
        get {
            return perspectiveImageView?.padding
        }
    }
    
    /*
     Minimum padding value for left and right sides
     If you set `paddingWidth` then `padding` is ignored for left and right sides
     */
    open var paddingWidth: CGFloat? {
        set {
            perspectiveImageView?.paddingWidth = newValue
            reset()
        }
        get {
            return perspectiveImageView?.paddingWidth
        }
    }
    
    /*
     Minimum padding value for top and bottom sides
     If you set `paddingWidth` then `padding` is ignored for top and bottom sides
     */
    open var paddingHeight: CGFloat? {
        set {
            perspectiveImageView?.paddingHeight = newValue
            reset()
        }
        get {
            return perspectiveImageView?.paddingHeight
        }
    }
    
    /*
     The color of box lines
     Default is `UIColor(red: 243.0/255.0, green: 231.0/255.0, blue: 109.0/255.0, alpha: 1.0)`
     */
    open var boxLineColor: UIColor? {
        didSet {
            setupRectangleLayer()
        }
    }
    
    /*
     The width of box lines. Default is `6`
     */
    open var boxLineWidth: CGFloat? {
        didSet {
            setupRectangleLayer()
        }
    }
    
    /*
     The size of checkpoint
     Default is CGSize(width: 80, height: 80)
     */
    open var pointSize: CGSize? {
        didSet {
            setupRectangleLayer()
        }
    }
    
    /*
     The color of checkpoint
     Default is UIColor.red
     */
    open var pointColor: UIColor? {
        didSet {
            setupRectangleLayer()
        }
    }
    
    /*
     The image of checkpoint
     If you set `pointImage` then `pointColor` is ignored
     */
    open var pointImage: UIImage? {
        didSet {
            setupRectangleLayer()
        }
    }
    
    /// MARK: - Private VARs
    
    private var perspectiveImageView: DDPerspectiveTransformImageView?
    private var points = [CGPoint]()
    private let rectangleLayer = CAShapeLayer()
    private let kDefaultPointSize = CGSize(width: 80, height: 80)
    
    /// MARK: - Life Cicle
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reset()
    }
    
    /// MARK: - Public
    
    open func cropAction() {
        guard var image = image else {
            return
        }
        image = image.fixOrientation()
        if let ciImage: CIImage = CIImage(image: image.fixOrientation()) {
            let croppedCIImage = getCroppedImage(image: ciImage, topL: points[0], topR: points[1], botL: points[3], botR: points[2])
            if let croppedImageCG = CIContext(options: nil).createCGImage(croppedCIImage, from: croppedCIImage.extent) {
                let croptedImage = UIImage(cgImage: croppedImageCG)
                delegate?.perspectiveTransformingDidFinish(controller: self, croppedImage: croptedImage)
            }
        }
    }
    
    open func cancelAction() {
        delegate?.perspectiveTransformingDidCancel(controller: self)
    }
    
    /// MARK: - Private
    
    private func reset() {
        perspectiveImageView?.setNeedsLayout()
        perspectiveImageView?.layoutIfNeeded()
        
        setupPoints()
        setupRectangleLayer()
    }
    
    private func setupPoints() {
        guard let perspectiveImageView = perspectiveImageView else {
            return
        }
        let frame = perspectiveImageView.frame
        
        let topL = CGPoint(x: frame.origin.x, y: frame.origin.y)
        let topR = CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
        let botR = CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + frame.size.height)
        let botL = CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height)
        
        points = [topL, topR, botR, botL]
    }
    
    private func setupRectangleLayer() {
        rectangleLayer.getPath(points: points, lineColor: boxLineColor, lineWidth: boxLineWidth)
        removePointsFromView()
        
        for point in points {
            let pointFrame = CGRect(origin: point, size: pointSize ?? kDefaultPointSize)
            let pointView = (pointImage != nil) ?
                DDPerspectiveTransformPointView(frame: pointFrame, image: pointImage) :
                DDPerspectiveTransformPointView(frame: pointFrame, color: pointColor)
            
            pointView.center = point
            pointView.isUserInteractionEnabled = true
            view.addSubview(pointView)
            
            let gr = UIPanGestureRecognizer(target: self, action: #selector(gesturePanAction(gr:)))
            pointView.addGestureRecognizer(gr)
        }
    }
    
    private func removePointsFromView() {
        view.subviews
            .lazy
            .filter { $0 is DDPerspectiveTransformPointView }
            .forEach { $0.removeFromSuperview() }
    }
    
    private func getCroppedImage(image: CIImage, topL: CGPoint, topR: CGPoint, botL: CGPoint, botR: CGPoint) -> CIImage {
        let rectCoords = NSMutableDictionary(capacity: 4)
        
        let offsetPoint = perspectiveImageView?.frame.origin ?? .zero
        let scaleRatio = perspectiveImageView?.scaleRatio ?? 1
        
        let aTopL = CGPoint(x: (topL.x - offsetPoint.x) / scaleRatio, y: (topL.y - offsetPoint.y) / scaleRatio)
        let aTopR = CGPoint(x: (topR.x - offsetPoint.x) / scaleRatio, y: (topR.y - offsetPoint.y) / scaleRatio)
        let aBotL = CGPoint(x: (botL.x - offsetPoint.x) / scaleRatio, y: (botL.y - offsetPoint.y) / scaleRatio)
        let aBotR = CGPoint(x: (botR.x - offsetPoint.x) / scaleRatio, y: (botR.y - offsetPoint.y) / scaleRatio)
        
        rectCoords["inputTopLeft"] = aTopL.toVector(image: image)
        rectCoords["inputTopRight"] = aTopR.toVector(image: image)
        rectCoords["inputBottomLeft"] = aBotL.toVector(image: image)
        rectCoords["inputBottomRight"] = aBotR.toVector(image: image)
        
        guard let coords = rectCoords as? [String : Any] else {
            return image
        }
        return image.applyingFilter("CIPerspectiveCorrection", parameters: coords)
    }
    
    @objc private func gesturePanAction(gr: UIPanGestureRecognizer) {
        let translation = gr.translation(in: view)
        if let view = gr.view {
            
            let oldPoint = view.center
            let newPoint = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            
            if changePoints(curPoint: oldPoint, destPoint: newPoint) {
                view.center = newPoint
                rectangleLayer.getPath(points: points, lineColor: boxLineColor, lineWidth: boxLineWidth)
            }
        }
        gr.setTranslation(.zero, in: view)
    }
    
    private func changePoints(curPoint: CGPoint, destPoint :CGPoint) -> Bool {
        guard let index = points.firstIndex(of: curPoint) else {
            return false
        }
        points.remove(at: index)
        points.insert(destPoint, at: index)
        return true
    }
}

extension CGPoint {
    func toVector(image: CIImage) -> CIVector {
        return CIVector(x: x, y: image.extent.height-y)
    }
}

extension CAShapeLayer {
    func getPath(points: [CGPoint], lineColor: UIColor? = nil, lineWidth: CGFloat? = nil) {
        
        guard points.count > 2 else {
            return
        }
        let defaultColor = UIColor(red: 243.0/255.0, green: 231.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        let defaultLineWidth: CGFloat = 6
        let aLineColor = lineColor ?? defaultColor
        let aLineWidth: CGFloat = lineWidth ?? defaultLineWidth
        let path = UIBezierPath()
        
        for (index, point) in points.enumerated() {
            switch index {
            case 0:
                path.move(to: point)
                
            case points.count-1:
                path.addLine(to: point)
                path.close()
                
            default:
                path.addLine(to: point)
            }
        }
        self.path = path.cgPath
        self.strokeColor = aLineColor.cgColor
        self.lineWidth = aLineWidth
        self.fillColor = UIColor.clear.cgColor
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        return self
    }
}
