//
//  NewsUsersInteractionCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

// MARK: - UITableViewCell
class NewsUsersInteractionCell: UITableViewCell {
    @IBOutlet weak var newsLikeButton: UIButton?
    @IBOutlet weak var newsCommentButton: UIButton?
    @IBOutlet weak var newsRepostButton: UIButton?
    @IBOutlet weak var newsViewsLabel: UILabel?
}

// MARK: - NewsProtocol
extension NewsUsersInteractionCell: NewsProtocol {
    
    // MARK: - setup
    func setup<T : NewsCellTypeDataProtocol>(news: T) {
        let likesCount = news.newsBody.likesCount != nil ? String(news.newsBody.likesCount!) : nil
        let commentsCount = news.newsBody.commentsCount != nil ? String(news.newsBody.commentsCount!) : nil
        let repostCount = news.newsBody.repostsCount != nil ? String(news.newsBody.repostsCount!) : nil
        let viewsCount = news.newsBody.viewsCount != nil ? String(news.newsBody.viewsCount!) : nil
        
        newsLikeButton?.setTitle(likesCount, for: .normal)
        newsCommentButton?.setTitle(commentsCount, for: .normal)
        newsRepostButton?.setTitle(repostCount, for: .normal)
        newsViewsLabel?.text = viewsCount
    }
}
