//
//  SquarePreviewImageView.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit
import func AVFoundation.AVMakeRect

class SquarePreviewImageView: UIImageView {

    // Resized large images to preview
    func resizedImage(at path: String, for size: CGSize) -> UIImage? {
        guard let image = UIImage(contentsOfFile: path) else {
            return nil
        }

        let rect = AVMakeRect(aspectRatio: image.size, insideRect: super.bounds)

        let renderer = UIGraphicsImageRenderer(size: rect.size)

        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: rect.size))
        }
    }
}
