//
//  NewsUsersInteractionCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

class NewsUsersInteractionCell: UITableViewCell {
    @IBOutlet weak var newsLikeButton: UIButton?
    @IBOutlet weak var newsCommentButton: UIButton?
    @IBOutlet weak var newsShareButton: UIButton?
    @IBOutlet weak var newsNumberOfViews: UILabel?
}

extension NewsUsersInteractionCell: NewsProtocol {
    func setup<T>(news: T) where T : NewsCellTypeDataProtocol {
        let numberOfLikes = news.numberOfLikes != nil ? String(news.numberOfLikes!) : nil
        let numberOfComments = news.numberOfComments != nil ? String(news.numberOfComments!) : nil
        let numberOfShares = news.numberOfShares != nil ? String(news.numberOfShares!) : nil
        let numberOfViews = news.numberOfViews != nil ? String(news.numberOfViews!) : nil

        newsLikeButton?.setTitle(numberOfLikes, for: .normal)
        newsCommentButton?.setTitle(numberOfComments, for: .normal)
        newsShareButton?.setTitle(numberOfShares, for: .normal)
        newsNumberOfViews?.text = numberOfViews
    }
}
