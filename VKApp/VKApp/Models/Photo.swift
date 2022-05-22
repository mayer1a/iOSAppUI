//
//  Photo.swift
//  VKApp
//
//  Created by Artem Mayer on 04.05.2022.
//

import Foundation


class Photo: Decodable {
    let id: Int
    var albumId: Int
    var ownerId: Int
    var smallSizeUrl: String
    var originalSizeUrl: String?
    var likesCounter: Int
    var isLiked: Int

    enum CodingKeys: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case sizes
        case likes
        case originalPhoto = "orig_photo"
    }

    enum SizesKeys: String, CodingKey {
        case url
        case type
    }

    enum LikedKeys: String, CodingKey {
        case likesCounter = "count"
        case isLiked = "user_likes"
    }

    enum OriginalPhotoKeys: String, CodingKey {
        case url
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)

        var sizesValues = try container.nestedUnkeyedContainer(forKey: .sizes)
        var smallSizeUrl: String?

        guard
            let countSizesValues = sizesValues.count
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: container.codingPath + [CodingKeys.sizes, SizesKeys.url],
                debugDescription: "size values container cannot be empty"))
        }

        while !sizesValues.isAtEnd {
            let sizesUrlValues = try sizesValues.nestedContainer(keyedBy: SizesKeys.self)
            let sizeType = try sizesUrlValues.decode(String.self, forKey: .type)

            if sizeType == "m" {
                smallSizeUrl = try sizesUrlValues.decode(String.self, forKey: .url)

                continue
            }

            if sizesValues.currentIndex == countSizesValues - 1 {
                originalSizeUrl = try sizesUrlValues.decode(String.self, forKey: .url)
            }
        }

        guard let smallSizeUrl = smallSizeUrl else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: container.codingPath + [CodingKeys.sizes, SizesKeys.url],
                debugDescription: "url cannot be empty"))
        }

        self.smallSizeUrl = smallSizeUrl

        let likesValues = try container.nestedContainer(keyedBy: LikedKeys.self, forKey: .likes)
        self.likesCounter = try likesValues.decode(Int.self, forKey: .likesCounter)
        self.isLiked = try likesValues.decode(Int.self, forKey: .isLiked)
    }
}


class PhotoResponse: Decodable {
    var count: Int
    var items: [Photo]

    enum CodingKeys: String, CodingKey {
        case response
    }

    enum RequestKeys: String, CodingKey {
        case count
        case items
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseValue = try container.nestedContainer(keyedBy: RequestKeys.self, forKey: .response)
        
        self.count = try responseValue.decode(Int.self, forKey: .count)
        self.items = try responseValue.decode([Photo].self, forKey: .items)
    }
}
