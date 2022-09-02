//
//  NewsTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 09.04.2022.
//

import UIKit

final class NewsAuthorDateTimeCell: UITableViewCell {
    @IBOutlet weak var newsAuthorAvatar: CircularPreviewImageView?
    @IBOutlet weak var newsAuthorFullName: UILabel?
    @IBOutlet weak var newsPostingDate: UILabel?
}

extension NewsAuthorDateTimeCell: NewsProtocol {
    func setup<T>(news: T) where T : NewsCellTypeDataProtocol {
        var fullName: String?
        var imageURL: URL?

        if let user = news.userOwner {
            fullName = "\(user.firstName) \(user.lastName)"
            imageURL = URL(string: user.avatar)
        } else if let group = news.groupOwner {
            fullName = "\(group.name)"
            imageURL = URL(string: group.avatar)
        }

        guard let imageURL = imageURL else { return }

        DispatchQueue.global().async { [weak self] in
            let image = UIImage.fetchImage(at: imageURL)

            DispatchQueue.main.async { [weak self] in
                self?.newsAuthorFullName?.text = fullName
                self?.newsAuthorAvatar?.image = image
                self?.newsPostingDate?.text = news.newsBody.date
            }
        }
    }
}
