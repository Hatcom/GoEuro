//
//  AnimatedButton.swift
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit

class AnimatedButton: UIButton {
    var progress: Float = 0.0 {
        didSet {
            let scaleFactor = progress < 0 ? 1 + progress : progress

            let scaleValue = CGFloat(0.85 + (scaleFactor * 0.15))

            transform = CGAffineTransform.identity.scaledBy(x: scaleValue, y: scaleValue)

            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(UIColor(red: 0.25, green: 0.34, blue: 0.69, alpha: 1.00).cgColor)

        if progress > 0 {
            context.fill(CGRect(origin: CGPoint(), size: CGSize(width: bounds.width * CGFloat(progress), height: bounds.height)))
        } else if progress < 0 {
            let originX = CGFloat(abs(progress)) * bounds.width
            context.fill(CGRect(origin: CGPoint(x: originX, y: 0), size: CGSize(width: bounds.width - originX, height: bounds.height)))
        }
    }
}
