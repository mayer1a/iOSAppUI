//
//  ShadowView.swift
//  VKApp
//
//  Created by Artem Mayer on 04.04.2022.
//

import UIKit

// MARK: - UIView
@IBDesignable final class ShadowView: UIView {
    @IBInspectable private var shadowColor: UIColor = .systemGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable private var shadowWidth: CGFloat = 3.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable private var shadowOpacity: Float = 1 {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()

        let cornerRadius = self.frame.width / 2

        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 7, height: 4)
        self.layer.shadowRadius = shadowWidth
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.cornerRadius = cornerRadius

        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.isOpaque = false
    }
}
