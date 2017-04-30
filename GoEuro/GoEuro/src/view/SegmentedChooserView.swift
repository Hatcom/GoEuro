//
//  SegmentedChooserView.swift
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit

@objc protocol SegmentedChooserViewDelegate: class {
    func segmentSelected(_ idx: Int)
}

class SegmentedChooserView: UIView {
    weak var delegate: SegmentedChooserViewDelegate?

    @IBOutlet weak var firstButton: AnimatedButton!
    @IBOutlet weak var secondButton: AnimatedButton!
    @IBOutlet weak var thirdButton: AnimatedButton!

    @IBAction func firstButtonTapped() {
        delegate?.segmentSelected(0)
    }

    @IBAction func secondButtonTapped() {
        delegate?.segmentSelected(1)
    }

    @IBAction func thirdButtonTapped() {
        delegate?.segmentSelected(2)
    }

    func selectWithRatio(_ ratio: CGFloat) {
        if (ratio == 0) {
            self.firstButton.progress = 1
            self.secondButton.progress = 0
            self.thirdButton.progress = 0
        } else if (ratio > 0 && ratio <= 1) {
            self.firstButton.progress = Float(0 - ratio)
            self.secondButton.progress = Float(ratio)
            self.thirdButton.progress = 0
        } else if (ratio > 1 && ratio <= 2) {
            self.firstButton.progress = 0
            self.secondButton.progress = Float(1 - ratio)
            self.thirdButton.progress = Float(ratio - 1)
        }
    }
}
