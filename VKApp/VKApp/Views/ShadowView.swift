//
//  ShadowView.swift
//  VKApp
//
//  Created by Artem Mayer on 04.04.2022.
//

import UIKit

@IBDesignable class ShadowView: UIView {

    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowWidth: CGFloat = 4.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.75 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius = self.frame.width / 2

        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 7, height: 5)
        self.layer.shadowRadius = shadowWidth
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        
        self.layer.cornerRadius = cornerRadius
    }
}
