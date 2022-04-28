//
//  SquarePreviewImageView.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit
import func AVFoundation.AVMakeRect

final class PreviewScaledImageView: UIImageView {

    // Resized large images to preview
    func resizedImage(at path: String, for size: CGSize) -> UIImage? {
        guard let image = UIImage(contentsOfFile: path) else { return nil }

        var rect = AVMakeRect(aspectRatio: image.size, insideRect: super.bounds)

        let height = rect.height * 0.75
        let width = rect.width * 0.75
        let size = CGSize(width: width, height: height)

        rect = CGRect(origin: rect.origin, size: size)
        let renderer = UIGraphicsImageRenderer(size: rect.size)

        let renderedImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: rect.size))
        }

        return renderedImage
    }
}
