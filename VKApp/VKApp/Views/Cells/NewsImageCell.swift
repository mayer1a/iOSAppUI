//
//  NewsImageCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

class NewsImageCell: UITableViewCell {
    @IBOutlet weak var newsImagesView: UIView?
    @IBOutlet weak var newsPhotoImageView: PreviewScaledImageView?
}

extension NewsImageCell: NewsProtocol {
    func setup<T>(news: T) where T : NewsCellTypeDataProtocol {
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
