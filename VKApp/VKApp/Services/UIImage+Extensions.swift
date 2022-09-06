//
//  UIImage+Extensions.swift
//  VKApp
//
//  Created by Artem Mayer on 03.09.22.
//

import UIKit
import func AVFoundation.AVMakeRect

// MARK: - UIImage. Fetch Image
extension UIImage {
    
    // MARK: - fetchImage
    static func fetchImage(at imageUrl: URL) -> UIImage? {
        guard
            let imageData = try? Data(contentsOf: imageUrl, options: .uncached),
            let image = UIImage(data: imageData)
        else { return nil }
        
        return image
    }
    
    // MARK: - resizeImage
    static func resizeImage(bounds: CGRect, image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        
        var rect = AVMakeRect(aspectRatio: image.size, insideRect: bounds)
        
        let height = rect.height
        let width = rect.width
        let size = CGSize(width: width, height: height)
        
        rect = CGRect(origin: rect.origin, size: size)
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        
        let renderedImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: rect.size))
        }
        
        return renderedImage
    }
}
