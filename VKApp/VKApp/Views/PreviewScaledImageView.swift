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
    func getImage(at imageUrl: URL) -> UIImage? {
        
        guard
            let imageData = try? Data(contentsOf: imageUrl, options: .uncached),
            let image = UIImage(data: imageData)
        else {
            return nil
        }

        return image
    }
}
