//
//  NewsAudioCell.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import UIKit

class NewsAudioCell: UITableViewCell {
    @IBOutlet weak var newsAudio: UILabel?
}

extension NewsAudioCell: NewsProtocol {
    func setup<T>(news: T) where T : NewsCellTypeDataProtocol {
        newsAudio?.text = news.audio
    }
}
