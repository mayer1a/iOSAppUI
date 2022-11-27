//
//  NewsImageCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

// MARK: - UITableViewCell
final class NewsImageCell: UITableViewCell {
    @IBOutlet weak var newsImagesView: UIView?
    @IBOutlet weak var newsPhotoImageView: PreviewScaledImageView?

    var indexPath: IndexPath?
    var imageCachingService: ImageCachingService?
}

// MARK: - NewsProtocol
extension NewsImageCell: NewsProtocol {
    
    // MARK: - setup
    func setup<T : NewsCellTypeDataProtocol>(news: T) {
        self.newsPhotoImageView?.image = nil
        
        guard let mainImage = news.newsBody.images.first,
              let imagePath = mainImage?.originalSizeUrl,
              let indexPath = indexPath
        else { return }
        
        imageCachingService?.getImage(at: indexPath, by: imagePath) { [weak self] image in
            self?.newsPhotoImageView?.image = image
        }
    }
}
