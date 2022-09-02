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
        var avatarUrl: URL?

        if let user = news.userOwner {
            fullName = "\(user.firstName) \(user.lastName)"
            avatarUrl = URL(string: user.avatar)
        } else if let group = news.groupOwner {
            fullName = "\(group.name)"
            avatarUrl = URL(string: group.avatar)
        }

        guard let avatarUrl = avatarUrl else { return }

        DispatchQueue.global().async { [weak self] in
            let avatar = self?.newsAuthorAvatar?.getImage(at: avatarUrl)

            DispatchQueue.main.async { [weak self] in
                self?.newsAuthorFullName?.text = fullName
                self?.newsAuthorAvatar?.image = avatar
                self?.newsPostingDate?.text = news.newsBody.date
            }
        }
    }
}
