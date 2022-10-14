//
//  NewsTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 09.04.2022.
//

import UIKit

// MARK: - UITableViewCell
final class NewsAuthorDateTimeCell: UITableViewCell {
    @IBOutlet weak var newsAuthorAvatar: CircularPreviewImageView?
    @IBOutlet weak var newsAuthorFullName: UILabel?
    @IBOutlet weak var newsPostingDate: UILabel?

    var imageCachingService: ImageCachingService?
    var indexPath: IndexPath?
}

// MARK: - NewsProtocol
extension NewsAuthorDateTimeCell: NewsProtocol {
    
    // MARK: - setup
    func setup<T : NewsCellTypeDataProtocol>(news: T) {
        var fullName: String?
        var imageURL = String()
        
        if let user = news.userOwner {
            fullName = "\(user.firstName) \(user.lastName)"
            imageURL = user.avatar
        } else if let group = news.groupOwner {
            fullName = "\(group.name)"
            imageURL = group.avatar
        }

        guard let indexPath = indexPath else { return }

        self.newsAuthorFullName?.text = fullName
        self.newsPostingDate?.text = news.newsBody.date
        self.newsAuthorAvatar?.image = imageCachingService?.getImage(at: indexPath, by: imageURL)
    }
}
