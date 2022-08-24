//
//  Photo.swift
//  VKApp
//
//  Created by Artem Mayer on 08.04.2022.
//

import Foundation

struct PhotoTestData {
    let id: Int
    var albumId: Int
    var ownerId: Int
    var smallSizeUrl: String
    var originalSizeUrl: String?
    var likesCounter: Int
    var isLiked: Int

    static var photos = [PhotoTestData(id: 645746,
                                       albumId: 546362,
                                       ownerId: 645353,
                                       smallSizeUrl: "p1",
                                       originalSizeUrl: "none",
                                       likesCounter: 12504,
                                       isLiked: 0),
                         PhotoTestData(id: 844391,
                                       albumId: 350881,
                                       ownerId: 645323,
                                       smallSizeUrl: "p2",
                                       likesCounter: 8084,
                                       isLiked: 0),
                         PhotoTestData(id: 323324,
                                       albumId: 397285,
                                       ownerId: 645343,
                                       smallSizeUrl: "p3",
                                       likesCounter: 5791,
                                       isLiked: 0),
                         PhotoTestData(id: 282976,
                                       albumId: 560183,
                                       ownerId: 945764,
                                       smallSizeUrl: "p4",
                                       likesCounter: 11313,
                                       isLiked: 1),
                         PhotoTestData(id: 443472,
                                       albumId: 441836,
                                       ownerId: 784374,
                                       smallSizeUrl: "p5",
                                       likesCounter: 12,
                                       isLiked: 1),
                         PhotoTestData(id: 289299,
                                       albumId: 372101,
                                       ownerId: 526374,
                                       smallSizeUrl: "p6",
                                       likesCounter: 4658,
                                       isLiked: 0),
                         PhotoTestData(id: 772733,
                                       albumId: 264578,
                                       ownerId: 193847,
                                       smallSizeUrl: "p7",
                                       likesCounter: 9156,
                                       isLiked: 0),
                         PhotoTestData(id: 486333,
                                       albumId: 385604,
                                       ownerId: 738473,
                                       smallSizeUrl: "p8",
                                       likesCounter: 433,
                                       isLiked: 0)]
}
