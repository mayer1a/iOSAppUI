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
    var userOwner: User? { get }
    var groupOwner: Group? { get }
    var newsBody: NewsBody { get }
}
