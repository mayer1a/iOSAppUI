//
//  NewsVideoCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

class NewsVideoCell: UITableViewCell {
    @IBOutlet weak var newsVideo: UILabel?
}

extension NewsVideoCell: NewsProtocol {
    func setup<T>(news: T) where T : NewsCellTypeDataProtocol {
        newsVideo?.text = news.video
    }
}
