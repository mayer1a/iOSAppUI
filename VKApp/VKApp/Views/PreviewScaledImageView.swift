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
    func resizedImage(at imageUrl: URL, for size: CGSize) -> UIImage? {
        
        guard
            let imageData = try? Data(contentsOf: imageUrl, options: .uncached),
            let image = UIImage(data: imageData)
        else {
            return nil
        }

        var rect = AVMakeRect(aspectRatio: image.size, insideRect: super.bounds)

        let height = rect.height
        let width = rect.width
        let size = CGSize(width: width, height: height)

        rect = CGRect(origin: rect.origin, size: size)
        let renderer = UIGraphicsImageRenderer(size: rect.size)

        let renderedImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: rect.size))
        }

        return renderedImage
    }
}
