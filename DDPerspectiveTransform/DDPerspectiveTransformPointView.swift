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

class DDPerspectiveTransformPointView: UIView {
    
    public var color: UIColor = UIColor.red {
        didSet {
            reset()
        }
    }
    
    public var image: UIImage? {
        set {
            pointImageView.image = newValue
            reset()
        }
        get {
            return pointImageView.image
        }
    }
    
    private let pointImageView = UIImageView()
    
    init(frame: CGRect, image: UIImage? = nil) {
        super.init(frame: frame)
        
        self.image = image
        if let _ = self.image {
            pointImageView.contentMode = .scaleAspectFit
        }
        addSubview(pointImageView)
        backgroundColor = UIColor.clear
    }
    
    init(frame: CGRect, color: UIColor? = nil) {
        super.init(frame: frame)
        
        if let aColor = color {
            self.color = aColor
        }
        addSubview(pointImageView)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reset()
    }
    
    private func reset() {
        pointImageView.frame.size = CGSize(width: bounds.size.width/2, height: bounds.size.height/2)
        pointImageView.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        if pointImageView.image == nil { /// if no image -> point
            pointImageView.backgroundColor = color
            pointImageView.layer.cornerRadius = pointImageView.frame.size.width/2
        }
    }
}
