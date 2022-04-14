//
//  PreviewImageView.swift
//  VKApp
//
//  Created by Artem Mayer on 28.03.2022.
//

import UIKit
import func AVFoundation.AVMakeRect

class CircularPreviewImageView: UIImageView {

    // MARK: layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.width / 2
    }

    // Resized large images to preview
    func resizedImage(at path: String, for size: CGSize) -> UIImage? {
        guard let image = UIImage(contentsOfFile: path) else { return nil }

        let rect = AVMakeRect(aspectRatio: image.size, insideRect: super.bounds)
        let rendered = UIGraphicsImageRenderer(size: rect.size)

        let rendredImage = rendered.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: rect.size))
        }

        return rendredImage
    }

}
