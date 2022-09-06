//
//  NewsAudioCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

// MARK: - UITableViewCell
final class NewsAudioCell: UITableViewCell {
    @IBOutlet weak var newsAudio: UILabel?
}

// MARK: - NewsProtocol
extension NewsAudioCell: NewsProtocol {
    func setup<T: NewsCellTypeDataProtocol>(news: T) {
        guard let audio = news.newsBody.audios.first
        else {
            newsAudio?.text = "[AUDIO]"
            return
        }
        
        newsAudio?.text = audio
    }
}
