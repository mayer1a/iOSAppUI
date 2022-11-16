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
    private var maskLayer = CAShapeLayer()

    // MARK: - layoutSubviews
    override func layoutSubviews () {
        super.layoutSubviews()

        let roundPath = UIBezierPath(roundedRect: bounds,
                                 byRoundingCorners: [.topLeft, .topRight],
                                 cornerRadii: CGSize(width: 30, height: 30))
        maskLayer.path = roundPath.cgPath
        self.layer.mask = maskLayer
    }
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
        self.newsPostingDate?.text = NewsDateFormatter.shared.getFormattedDate(from: news.newsBody.date)
        self.newsAuthorAvatar?.image = imageCachingService?.getImage(at: indexPath, by: imageURL)
    }
}
