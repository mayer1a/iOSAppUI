//
//  ShadowView.swift
//  VKApp
//
//  Created by Artem Mayer on 04.04.2022.
//

import UIKit

// MARK: - UIView
@IBDesignable final class ShadowView: UIView {
    @IBInspectable private var shadowColor: UIColor = .systemGray3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable private var shadowWidth: CGFloat = 4.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable private var shadowOpacity: Float = 0.75 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - layoutSubviews
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
