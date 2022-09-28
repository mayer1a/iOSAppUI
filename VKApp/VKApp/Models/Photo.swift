//
//  Photo.swift
//  VKApp
//
//  Created by Artem Mayer on 04.05.2022.
//

import Foundation
import RealmSwift
import Realm

// MARK: - SizeType
enum SizeType: String, Decodable {
    case a, b, c, d, e, k, l, m, o, p, q, r, s, w, x, y, z
}

// MARK: - PhotoSizes
final class PhotoSizes: Decodable {
    enum CodingKeys: String, CodingKey {
        case url
        case type
        case width
        case height
    }

    let url: String?
    let type: SizeType?
    let width: Int
    let height: Int

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.url = try container.decode(String.self, forKey: .url)
        self.type = try container.decode(SizeType.self, forKey: .type)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
    }

    required init(
        url: String?,
        type: SizeType?,
        width: Int,
        height: Int
    ) {
        self.url = url
        self.type = type
        self.width = width
        self.height = height
    }
}

// MARK: - Photo
final class Photo: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case sizes
        case likes
    }
    
    enum LikedKeys: String, CodingKey {
        case likesCounter = "count"
        case isLiked = "user_likes"
    }
    
    let id: Int
    var albumId: Int
    var ownerId: Int
    var smallSizeUrl: String?
    var originalSizeUrl: String?
    var sizes: [PhotoSizes]
    var likesCounter: Int?
    var isLiked: Int?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var sizesValues = try container.nestedUnkeyedContainer(forKey: .sizes)

        self.id = try container.decode(Int.self, forKey: .id)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        self.sizes = []

        while !sizesValues.isAtEnd {
            let size = try sizesValues.decode(PhotoSizes.self)
            self.sizes.append(size)

            switch size.type {
                case .m: self.smallSizeUrl = size.url
                case .z: self.originalSizeUrl = size.url
                default: break
            }
        }

        DispatchQueue.global().async { [weak self] in
            if self?.smallSizeUrl == nil {
                self?.smallSizeUrl = self?.sizes.first(where: { $0.url != nil })?.url
            }

            if self?.originalSizeUrl == nil {
                self?.originalSizeUrl = self?.sizes.last(where: { $0.url != nil })?.url
            }
        }
        
        let likesValues = try? container.nestedContainer(keyedBy: LikedKeys.self, forKey: .likes)
        self.likesCounter = try? likesValues?.decode(Int.self, forKey: .likesCounter)
        self.isLiked = try? likesValues?.decode(Int.self, forKey: .isLiked)
    }
    
    required init(
        id: Int,
        albumId: Int,
        ownerId: Int,
        smallSizeUrl: String?,
        originalSizeUrl: String?,
        sizes: [PhotoSizes] = [],
        likesCounter: Int?,
        isLiked: Int?
    ) {
        self.id = id
        self.albumId = albumId
        self.ownerId = ownerId
        self.smallSizeUrl = smallSizeUrl
        self.originalSizeUrl = originalSizeUrl
        self.sizes = sizes
        self.likesCounter = likesCounter
        self.isLiked = isLiked
    }
}


// MARK: - PhotoResponse
final class PhotoResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    enum RequestKeys: String, CodingKey {
        case count
        case items
    }
    
    var count: Int
    var items: [Photo]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseValue = try container.nestedContainer(keyedBy: RequestKeys.self, forKey: .response)
        
        self.count = try responseValue.decode(Int.self, forKey: .count)
        self.items = try responseValue.decode([Photo].self, forKey: .items)
    }
}
