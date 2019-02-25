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

class DDPerspectiveTransformImageView: UIImageView {
    
    public private(set) var scaleRatio: CGFloat = 1.0
    
    var padding: CGFloat? {
        didSet {
            reset()
        }
    }
    
    var paddingWidth: CGFloat? {
        didSet {
            reset()
        }
    }
    
    var paddingHeight: CGFloat? {
        didSet {
            reset()
        }
    }
    
    private weak var aSuperView: UIView?
    
    init(image: UIImage, aSuperView: UIView) {
        super.init(image: image)
        
        self.aSuperView = aSuperView
        contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reset()
    }
    
    private func reset() {
        guard let image = image else {
            return
        }
        guard let aSuperView = aSuperView else {
            return
        }
        let superViewFrame = aSuperView.frame
        
        let offsetW = image.size.width - superViewFrame.size.width
        let offsetH = image.size.height - superViewFrame.size.height
        
        let paddingW: CGFloat = self.paddingWidth ?? (padding ?? superViewFrame.size.width / 8.0)
        let paddingH: CGFloat = self.paddingHeight ?? (padding ?? superViewFrame.size.height / 8.0)
        let aspectRatio: CGFloat = superViewFrame.size.width / superViewFrame.size.height
        
        if offsetW > (offsetH * aspectRatio) { // wide image
            let normW = superViewFrame.size.width - 2*paddingW
            if image.size.width - normW > 0 {
                scaleRatio = (superViewFrame.size.width - 2*paddingW) / image.size.width
            }
        } else { // high picture
            let normH = superViewFrame.size.height - 2*paddingH
            if image.size.height - normH > 0 {
                scaleRatio = (superViewFrame.size.height - 2*paddingH) / image.size.height
            }
        }
        frame.size = CGSize(width: image.size.width * scaleRatio, height: image.size.height * scaleRatio)
        center = aSuperView.center
    }
    
}
