//
//  NewsProtocol.swift
//  VKApp
//
//  Created by Artem Mayer on 24.08.22.
//

import Foundation

protocol NewsProtocol {
    func setup<T>(news: T) where T: NewsCellTypeDataProtocol
}

protocol NewsCellTypeDataProtocol {
    var user: UserTestData? { get }
    var postingDate: String? { get }
    var text: String? { get }
    var images: PhotoTestData? { get }
    var audio: String? { get }
    var video: String? { get }
    var numberOfViews: Int? { get }
    var numberOfLikes: Int? { get }
    var numberOfComments: Int? { get }
    var numberOfShares: Int? { get }
}
