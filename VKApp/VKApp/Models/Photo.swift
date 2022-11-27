//
//  Photo.swift
//  VKApp
//
//  Created by Artem Mayer on 04.05.2022.
//

import Foundation

// MARK: - SizeType
enum SizeType: String, Decodable {
    case a, b, c, d, e, k, l, m, o, p, q, r, s, w, x, y, z
}

// MARK: - PhotoSizes
final class PhotoSize: Decodable {
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
        case reposts
        case comments
        case text
        case canRepost = "can_repost"
        case canComment = "can_comment"
    }
    
    enum LikesKeys: String, CodingKey {
        case likesCount = "count"
        case isLiked = "user_likes"
    }

    enum RepostsKeys: String, CodingKey {
        case repostsCount
        case isReposted = "user_reposted"
    }

    enum CommentsKeys: String, CodingKey {
        case commentsCount
    }
    
    let id: Int
    let albumId: Int
    let ownerId: Int
    var smallSizeUrl: String?
    var originalSizeUrl: String?
    var aspectRatio: Double?
    var likesCounter: Int?
    var isLiked: Bool?
    var repostsCount: Int?
    var isReposted: Bool?
    var canRepost: Bool?
    var commentsCount: Int?
    var canComment: Bool?
    var text: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let likesValues = try? container.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        let repostsValues = try? container.nestedContainer(keyedBy: RepostsKeys.self, forKey: .reposts)
        let commentsValues = try? container.nestedContainer(keyedBy: CommentsKeys.self, forKey: .comments)
        var sizesValues = try container.nestedUnkeyedContainer(forKey: .sizes)

        self.id = try container.decode(Int.self, forKey: .id)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)

        self.likesCounter = try? likesValues?.decode(Int.self, forKey: .likesCount)
        self.isLiked = (try? likesValues?.decode(Int.self, forKey: .isLiked)) == 1 ? true : false

        self.repostsCount = try? repostsValues?.decode(Int.self, forKey: .repostsCount)
        self.isReposted = (try? repostsValues?.decode(Int.self, forKey: .isReposted)) == 1 ? true : false
        self.canRepost = (try? container.decode(Int.self, forKey: .canRepost)) == 1 ? true : false

        self.commentsCount = try? commentsValues?.decode(Int.self, forKey: .commentsCount)
        self.canComment = (try? container.decode(Int.self, forKey: .canComment)) == 1 ? true : false

        self.text = try? container.decode(String.self, forKey: .text)

        var sizes = [PhotoSize]()

        while !sizesValues.isAtEnd {
            let sizeValue = try sizesValues.decode(PhotoSize.self)
            sizes.append(sizeValue)

            switch sizeValue.type {
                case .m: self.smallSizeUrl = sizeValue.url
                case .z:
                    self.originalSizeUrl = sizeValue.url
                    self.aspectRatio = Double(sizeValue.height) / Double(sizeValue.width)
                default: break
            }
        }

        DispatchQueue.global().async { [weak self] in
            if self?.smallSizeUrl == nil, let size = sizes.first(where: { $0.url != nil })?.url {
                DispatchQueue.main.async { [weak self] in
                    self?.smallSizeUrl = size
                }
            }

            if self?.originalSizeUrl == nil, let size = sizes.last(where: { $0.url != nil }) {
                DispatchQueue.main.async { [weak self] in
                    self?.originalSizeUrl = size.url
                    self?.aspectRatio = Double(size.height) / Double(size.width)
                }
            }
        }
    }

    /// Init for the Realm
    required init(
        id: Int,
        albumId: Int,
        ownerId: Int,
        smallSizeUrl: String?,
        originalSizeUrl: String?,
        aspectRatio: Double?,
        likesCounter: Int?,
        isLiked: Bool?,
        repostsCount: Int?,
        isReposted: Bool?,
        canRepost: Bool?,
        commentsCount: Int?,
        canComment: Bool?,
        text: String?
    ) {
        self.id = id
        self.albumId = albumId
        self.ownerId = ownerId
        self.smallSizeUrl = smallSizeUrl
        self.originalSizeUrl = originalSizeUrl
        self.aspectRatio = aspectRatio
        self.likesCounter = likesCounter
        self.isLiked = isLiked
        self.repostsCount = repostsCount
        self.isReposted = isReposted
        self.canRepost = canRepost
        self.commentsCount = commentsCount
        self.canComment = canComment
        self.text = text
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
