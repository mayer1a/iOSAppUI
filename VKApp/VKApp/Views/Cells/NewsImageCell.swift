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
}

// MARK: - NewsProtocol
extension NewsImageCell: NewsProtocol {
    
    // MARK: - setup
    func setup<T: NewsCellTypeDataProtocol>(news: T) {
        self.newsPhotoImageView?.image = nil
        
        guard let mainImage = news.newsBody.images.first,
              let imageName = mainImage?.originalSizeUrl,
              let imageUrl = URL(string: imageName)
        else { return }
        
        DispatchQueue.global().async { [weak self] in
            let image = UIImage.fetchImage(at: imageUrl)
            
            DispatchQueue.main.async { [weak self] in
                self?.newsPhotoImageView?.image = image
            }
        }
    }
}
