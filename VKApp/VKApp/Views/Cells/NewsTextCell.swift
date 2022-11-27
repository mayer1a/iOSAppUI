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

    private let linkRegex = try? NSRegularExpression(pattern: "(?i)https?:\\/\\/(?:www\\.)?\\S+(?:\\/|\\b)")
    private let hashtagRegex = try? NSRegularExpression(pattern: "(?i)#\\S+(?:\\/|\\b)")
    private lazy var textRange: NSRange = {
        return NSRange(location: 0, length: 0)
    }()
    private lazy var paragraphStyle = {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping

        return style
    }()

    var cellId: Int?
}

// MARK: - NewsProtocol
extension NewsTextCell: NewsProtocol {
    func setup<T : NewsCellTypeDataProtocol>(news: T) {
        guard
            self.cellId == self.showMoreButton?.tag,
            let text = news.newsBody.text,
            let linkRegex = linkRegex,
            let hashtagRegex = hashtagRegex
        else {
            self.showMoreButton?.isHidden = true

            return
        }

        self.textRange.length = text.count

        let attributedString = NSMutableAttributedString(string: text)
        let linksMatches = linkRegex.matches(in: text, range: self.textRange)
        let tagsMatches = hashtagRegex.matches(in: text, range: self.textRange)
        var rangeText = ""

        linksMatches.enumerated().forEach { (index, item) in
            if let range = Range(item.range, in: text) {
                rangeText = String(text[range])

                let attributes: [NSAttributedString.Key : Any] = [.link : rangeText]
                let urlAttributedString = NSAttributedString(string: rangeText, attributes: attributes)

                attributedString.replaceCharacters(in: item.range, with: urlAttributedString)
            }
        }

        tagsMatches.enumerated().forEach { (index, item) in
            if let range = Range(item.range, in: text) {
                rangeText = String(text[range])

                let attributes: [NSAttributedString.Key : Any] = [.link : rangeText]
                let urlAttributedString = NSAttributedString(string: rangeText, attributes: attributes)

                attributedString.replaceCharacters(in: item.range, with: urlAttributedString)
            }
        }

        textRange.length = attributedString.length
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: textRange)

        self.newsText?.attributedText = attributedString

        if self.newsText?.isOversizeLabel() == true {
            self.showMoreButton?.isHidden = false
        } else {
            self.showMoreButton?.isHidden = true
        }
    }
}

