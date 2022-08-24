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
        guard let userFirstName = news.user?.firstName,
              let userLastName = news.user?.lastName,
              let userAvatarName = news.user?.avatar,
              let userAvatarPath = Bundle.main.path(forResource: userAvatarName, ofType: "jpg"),
              let userAvatar = UIImage(contentsOfFile: userAvatarPath)
        else { return }

        newsAuthorFullName?.text = "\(userFirstName) \(userLastName)"
        newsAuthorAvatar?.image = userAvatar
        newsPostingDate?.text = news.postingDate
    }
}
