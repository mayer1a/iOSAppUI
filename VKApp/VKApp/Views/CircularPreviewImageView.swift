//
//  PreviewImageView.swift
//  VKApp
//
//  Created by Artem Mayer on 28.03.2022.
//

import UIKit
import func AVFoundation.AVMakeRect

final class CircularPreviewImageView: UIImageView {

    // MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.width / 2
    }
}
