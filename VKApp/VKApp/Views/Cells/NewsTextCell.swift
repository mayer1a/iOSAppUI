//
//  NewsTextCellTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

class NewsTextCell: UITableViewCell {
    @IBOutlet weak var newsText: UILabel?
}

extension NewsTextCell: NewsProtocol {
    func setup<T>(news: T) where T : NewsCellTypeDataProtocol {
        newsText?.text = news.newsBody.text
    }
}
