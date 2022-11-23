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
//        newsText?.text = news.newsBody.text

        let text = news.newsBody.text

        DispatchQueue.global().async {
            let linkRegex = try? NSRegularExpression(pattern: "(?i)https?:\\/\\/(?:www\\.)?\\S+(?:\\/|\\b)")
            let hashtagRegex = try? NSRegularExpression(pattern: "(?i)#\\S+(?:\\/|\\b)")

            if let text = text, let linkRegex = linkRegex, let hashtagRegex = hashtagRegex {
                let attributedString = NSMutableAttributedString(string: text)
                let textRange = NSRange(location: 0, length: text.count)

                let linksMatches = linkRegex.matches(in: text, range: textRange)
                let tagsMatches = hashtagRegex.matches(in: text, range: textRange)

                linksMatches.enumerated().forEach { (index, item) in
                    if let range = Range(item.range, in: text), let url = URL(string: String(text[range])) {
                        let attributes: [NSAttributedString.Key : Any] = [.link : url]
                        let urlAttributedString = NSAttributedString(string: String(text[range]), attributes: attributes)

                        attributedString.replaceCharacters(in: item.range, with: urlAttributedString)
                    }
                }

                tagsMatches.enumerated().forEach { (index, item) in
                    if let range = Range(item.range, in: text) {
                        let attributes: [NSAttributedString.Key : Any] = [.link : String(text[range])]
                        let urlAttributedString = NSAttributedString(string: String(text[range]), attributes: attributes)

                        attributedString.replaceCharacters(in: item.range, with: urlAttributedString)
                    }
                }

                DispatchQueue.main.async { [weak self] in
                    self?.newsText?.attributedText = attributedString

                    guard self?.cellId == self?.showMoreButton?.tag else { return }

                    if self?.newsText?.isOversizeLabel() == true {
                        self?.showMoreButton?.isHidden = false
                    } else {
                        self?.showMoreButton?.isHidden = true
                    }
                }
            }
        }

    }
}

extension NSAttributedString.Key {
    static let hyperlink = NSAttributedString.Key("hyperlink")
}
