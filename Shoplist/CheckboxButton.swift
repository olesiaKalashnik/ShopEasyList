//
//  CheckboxButton.swift
//  Shopping List_v.2.0
//
//  Created by Olesia Kalashnik on 6/30/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class CheckboxButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private var circleLayer = CAShapeLayer()
    private var fillCircleLayer = CAShapeLayer()
    override var selected: Bool {
        didSet {
            toggleButton()
        }
    }
    
    @IBInspectable var circleLayerColor = UIColor.lightGrayColor().CGColor {
        didSet {
            circleLayer.strokeColor = circleLayerColor
        }
    }
    
    @IBInspectable var circleFillColor = Defaults.UI.blueSolid.CGColor {
        didSet {
            fillCircleLayer.fillColor = circleFillColor
        }
    }
    
    @IBInspectable var circleRadius : CGFloat = 10.0
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    private func circleFrame() -> CGRect {
        var cFrame = CGRect(x: 0.0, y: 0.0, width: circleRadius*2, height: circleRadius*2)
        cFrame.origin.x = CGFloat(8.0) + circleLayer.lineWidth
        cFrame.origin.y = bounds.height/2 - cFrame.height/2
        return cFrame
    }
    
    func toggleButton() {
        if self.selected {
            fillCircleLayer.fillColor = circleFillColor
            circleLayer.strokeColor = circleFillColor
        } else {
            fillCircleLayer.fillColor = UIColor.clearColor().CGColor
            circleLayer.strokeColor = circleLayerColor
        }
    }
    
    func setup() {
        circleLayer.frame = bounds
        circleLayer.lineWidth = 1.0
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = circleLayerColor
        layer.addSublayer(circleLayer)
        
        fillCircleLayer.frame = bounds
        fillCircleLayer.lineWidth = 0.5
        fillCircleLayer.fillColor = circleFillColor
        fillCircleLayer.strokeColor = circleLayerColor
        layer.addSublayer(fillCircleLayer)
        
        toggleButton()
    }
    
    private var circlePath : CGPath {
        get {
            return UIBezierPath(ovalInRect: circleFrame()).CGPath
        }
    }
    
    private var fillCirclePath : CGPath {
        get {
            return UIBezierPath(ovalInRect: CGRectInset(circleFrame(), 2.0, 2.0)).CGPath
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = bounds
        circleLayer.path = circlePath
        fillCircleLayer.frame = bounds
        fillCircleLayer.path = fillCirclePath
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
}

