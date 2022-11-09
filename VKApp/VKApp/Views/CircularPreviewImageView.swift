//
//  PreviewImageView.swift
//  VKApp
//
//  Created by Artem Mayer on 28.03.2022.
//

import UIKit

// MARK: - UIImageView
final class CircularPreviewImageView: UIImageView {
    // MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = self.frame.width / 2
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.isOpaque = false
    }
}
