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
        guard let imageName = news.images?.smallSizeUrl,
              let imagePath = Bundle.main.path(forResource: imageName, ofType: "jpg"),
              let image = UIImage(contentsOfFile: imagePath)
        else { return }

        newsPhotoImageView?.image = image
    }
}
