//
//  NewsProtocol.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import Foundation

// MARK: - NewsProtocol
protocol NewsProtocol {
    func setup<T: NewsCellTypeDataProtocol>(news: T)
}

// MARK: - NewsCellTypeDataProtocol
protocol NewsCellTypeDataProtocol {
    var userOwner: User? { get }
    var groupOwner: Community? { get }
    var newsBody: NewsBody { get }
}
