//
//  NewsTextCellTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

// MARK: - UITableViewCell
final class NewsTextCell: UITableViewCell {
    @IBOutlet weak var newsText: UILabel?
    @IBOutlet weak var showMoreButton: UIButton?

    var cellId: Int?
}

// MARK: - NewsProtocol
extension NewsTextCell: NewsProtocol {
    func setup<T : NewsCellTypeDataProtocol>(news: T) {
        newsText?.text = news.newsBody.text
        
        guard cellId == showMoreButton?.tag else { return }

        if newsText?.isOversizeLabel() == true {
            showMoreButton?.isHidden = false
        } else {
            showMoreButton?.isHidden = true
        }
    }
}
