//
//  NewsVideoCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

// MARK: - UITableViewCell
final class NewsVideoCell: UITableViewCell {
    @IBOutlet weak var newsVideo: UILabel?
}

// MARK: - NewsProtocol
extension NewsVideoCell: NewsProtocol {
    
    // MARK: - setup
    func setup<T : NewsCellTypeDataProtocol>(news: T) {
        guard
            let video = news.newsBody.videos.first,
            let title = video?.title
        else { return }
        
        newsVideo?.text = "[VIDEO TITLE]: \(title)"
    }
}
