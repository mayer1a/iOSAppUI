//
//  UILabel+Extension.swift
//  VKApp
//
//  Created by Artem Mayer on 13.11.2022.
//

import UIKit

// MARK: - UILabel
extension UILabel {

    // MARK: - isOversizeLabel
    func isOversizeLabel() -> Bool {
        self.sizeToFit()
        
        return self.frame.height > CGFloat(200)
    }

    // MARK: - newsLabelSize
    func newsLabelSize() -> CGFloat {
        return self.textRect(forBounds: self.bounds, limitedToNumberOfLines: 9).height
    }
}
