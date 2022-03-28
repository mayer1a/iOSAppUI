//
//  PreviewImageView.swift
//  VKApp
//
//  Created by Artem Mayer on 28.03.2022.
//

import UIKit

class PreviewImageView: UIImageView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = rect.width / 2
        self.clipsToBounds = true
    }

}
