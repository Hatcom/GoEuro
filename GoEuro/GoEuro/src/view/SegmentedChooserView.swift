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

    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBAction func firstButtonTapped() {
        delegate?.segmentSelected(0)
    }

    @IBAction func secondButtonTapped() {
        delegate?.segmentSelected(1)
    }

    @IBAction func thirdButtonTapped() {
        delegate?.segmentSelected(2)
    }
}
