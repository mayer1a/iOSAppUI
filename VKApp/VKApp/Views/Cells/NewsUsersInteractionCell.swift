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

    private var canLike: Bool = false
    private var isLiked: Bool?
    private var maskLayer = CAShapeLayer()

    var delegate: NewsInteractionProtocol?
    var cellId: IndexPath?



    // MARK: - layoutSubviews
    override func layoutSubviews () {
        super.layoutSubviews()

        let roundPath = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft, .bottomRight],
                                 cornerRadii: CGSize(width: 30, height: 30))
        maskLayer.path = roundPath.cgPath
        self.layer.mask = maskLayer
    }

    // MARK: - likeButtonDidTapped
    @IBAction func likeButtonDidTapped(_ sender: Any) {
        if canLike {
            isLiked?.toggle()
            delegate?.newsLikeButtonDidTapped(isLiked, by: cellId)
        }
    }
}

// MARK: - NewsUsersInteractionCell
extension NewsUsersInteractionCell {

    // MARK: - clearReuseCell
    func resetSubviews() {
        self.newsLikeButton?.setTitle("", for: .normal)
        self.newsLikeButton?.setImage(UIImage(systemName: "heart"), for: .normal)
        self.newsCommentButton?.setTitle("", for: .normal)
        self.newsRepostButton?.setTitle("", for: .normal)
        self.newsViewsLabel?.text = ""
        self.isLiked = nil
    }
}

// MARK: - NewsProtocol
extension NewsUsersInteractionCell: NewsProtocol {
    
    // MARK: - setup
    func setup<T : NewsCellTypeDataProtocol>(news: T) {
        self.resetSubviews()

        DispatchQueue.global().async { [weak self] in
            self?.isLiked = news.newsBody.isLiked == 1 ? true : false
            self?.canLike = news.newsBody.canLike == 1 ? true : false

            let likesCount = news.newsBody.likesCount != nil ? String(news.newsBody.likesCount!) : nil
            let commentsCount = news.newsBody.commentsCount != nil ? String(news.newsBody.commentsCount!) : nil
            let repostCount = news.newsBody.repostsCount != nil ? String(news.newsBody.repostsCount!) : nil
            let viewsCount = news.newsBody.viewsCount != nil ? String(news.newsBody.viewsCount!) : nil
            let color = self?.isLiked ?? false ? UIColor.systemRed : UIColor.systemGray
            let image = self?.isLiked ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")

            DispatchQueue.main.async { [weak self] in
                self?.newsLikeButton?.setTitle(likesCount, for: .normal)
                self?.newsLikeButton?.setImage(image, for: .normal)
                self?.newsLikeButton?.tintColor = color
                self?.newsCommentButton?.setTitle(commentsCount, for: .normal)
                self?.newsRepostButton?.setTitle(repostCount, for: .normal)
                self?.newsViewsLabel?.text = viewsCount
            }
        }
    }
}
