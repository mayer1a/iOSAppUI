//
//  s.swift
//  VKApp
//
//  Created by Artem Mayer on 03.09.22.
//

import UIKit

// MARK: - UIImage. Fetch Image
extension UIImage {

    static func fetchImage(at imageUrl: URL) -> UIImage? {
        guard
            let imageData = try? Data(contentsOf: imageUrl, options: .uncached),
            let image = UIImage(data: imageData)
        else { return nil }

        return image
    }
}
