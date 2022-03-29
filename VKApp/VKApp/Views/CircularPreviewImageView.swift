//
//  PreviewImageView.swift
//  VKApp
//
//  Created by Artem Mayer on 28.03.2022.
//

import UIKit

class CircularPreviewImageView: UIImageView {

    // MARK: layoutSubviews
    override func layoutSubviews() {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.borderWidth = 0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
