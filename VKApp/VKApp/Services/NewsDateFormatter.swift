//
//  NewsDateFormatter.swift
//  VKApp
//
//  Created by Artem Mayer on 12.11.2022.
//

import Foundation

// MARK: - NewsDateFormatter
class NewsDateFormatter {
    private init() {}
    private let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.timeZone = .current

        return dateFormatter
    }()

    static let shared = NewsDateFormatter()

    // MARK: - newsFormattedDate
    func getFormattedDate(from date: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: date)
        return dateFormatter.string(from: date)
    }
}
