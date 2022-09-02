//
//  News.swift
//  VKApp
//
//  Created by Artem Mayer on 29.08.22.
//

import UIKit

// MARK: - NewsBody
class NewsBody: Decodable {
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case isFavorite = "is_favorite"
        case markedAsAds = "marked_as_ads"
        case postSource = "post_source"
        case postID = "post_id"
        case signerID = "signer_id"
        case topicID = "topic_id"
        case date
        case text
        case reposts
        case comments
        case likes
        case views
        case attachments
    }

    enum LikesKeys: String, CodingKey {
        case canLike = "can_like"
        case isLiked = "user_likes"
        case likesCount = "count"
        case canRepost = "can_publish"
    }

    enum RepostsKeys: String, CodingKey {
        case repostsCount = "count"
        case isReposted = "user_reposted"
    }

    enum ViewsKeys: String, CodingKey {
        case viewsCount = "count"
    }

    enum CommentsKeys: String, CodingKey {
        case commentsCount = "count"
        case canPostComment = "can_post"
    }

    enum AttachmentsKeys: String, CodingKey {
        case type
        case photo
    }

    let sourceId: Int
    let date: String
    let markedAsAds: Int?
    let postID: Int?
    let signerID: Int?
    let topicID: Int?
    var canDoubtCategory: Bool?
    var canSetCategory: Bool?
    var isFavorite: Bool?
    var text: String?
    var commentsCount: Int?
    var canPostComment: Int?
    var likesCount: Int?
    var canLike: Int?
    var isLiked: Int?
    var repostsCount: Int?
    var isReposted: Int?
    var canRepost: Int?
    var viewsCount: Int?
    var images: [Photo?]
    var audios: [String?]
    var videos: [String?]

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)

        let dateValue = try container.decode(Int.self, forKey: .date)
        let date = Date(timeIntervalSince1970: TimeInterval(dateValue))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy hh:mm"
        dateFormatter.timeZone = .current
        self.date = dateFormatter.string(from: date)

        self.canDoubtCategory = try? container.decode(Bool.self, forKey: .canDoubtCategory)
        self.canSetCategory = try? container.decode(Bool.self, forKey: .canSetCategory)
        self.isFavorite = try? container.decode(Bool.self, forKey: .isFavorite)
        self.markedAsAds = try? container.decode(Int.self, forKey: .markedAsAds)
        self.postID = try? container.decode(Int.self, forKey: .postID)
        self.signerID = try? container.decode(Int.self, forKey: .signerID)
        self.topicID = try? container.decode(Int.self, forKey: .topicID)
        self.text = try? container.decode(String.self, forKey: .text)

        let nestedLikesContainer = try? container.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likesCount = try? nestedLikesContainer?.decode(Int.self, forKey: .likesCount)
        self.canLike = try? nestedLikesContainer?.decode(Int.self, forKey: .canLike)
        self.isLiked = try? nestedLikesContainer?.decode(Int.self, forKey: .isLiked)
        self.canRepost = try? nestedLikesContainer?.decode(Int.self, forKey: .canRepost)

        let nestedCommentsContainer = try? container.nestedContainer(keyedBy: CommentsKeys.self, forKey: .comments)
        self.commentsCount = try? nestedCommentsContainer?.decode(Int.self, forKey: .commentsCount)
        self.canPostComment = try? nestedCommentsContainer?.decode(Int.self, forKey: .canPostComment)

        let nestedRepostsContainer = try? container.nestedContainer(keyedBy: RepostsKeys.self, forKey: .reposts)
        self.repostsCount = try? nestedRepostsContainer?.decode(Int.self, forKey: .repostsCount)
        self.isReposted = try? nestedRepostsContainer?.decode(Int.self, forKey: .isReposted)

        let nestedViewsContainer = try? container.nestedContainer(keyedBy: ViewsKeys.self, forKey: .views)
        self.viewsCount = try? nestedViewsContainer?.decode(Int.self, forKey: .viewsCount)

        var nestedUnkeyedImageContainer = try? container.nestedUnkeyedContainer(forKey: .attachments)
        self.images = [Photo]()

        while !(nestedUnkeyedImageContainer?.isAtEnd ?? true) {
            let nestedImageContainer = try? nestedUnkeyedImageContainer?.nestedContainer(keyedBy: AttachmentsKeys.self)
            let attachmentsType = try? nestedImageContainer?.decode(String.self, forKey: .type)

            if attachmentsType == "photo" {
                let image = try? nestedImageContainer?.decode(Photo.self, forKey: .photo)
                self.images.append(image)
            }
        }

        self.audios = [String?]()
        self.videos = [String?]()
    }
}

// MARK: - NewsResponse
class NewsResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case response
    }

    enum RequestKeys: String, CodingKey {
        case items
        case users = "profiles"
        case groups
        case nextFrom = "next_from"
    }

    private var items: [NewsBody]?
    private var groups: [Group]?
    private var users: [User]?
    var nextFrom: String?
    var news: [News]

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseValue = try container.nestedContainer(keyedBy: RequestKeys.self, forKey: .response)

        self.items = try responseValue.decode([NewsBody]?.self, forKey: .items)
        self.groups = try responseValue.decode([Group].self, forKey: .groups)
        self.users = try responseValue.decode([User].self, forKey: .users)
        self.nextFrom = try? responseValue.decode(String.self, forKey: .nextFrom)
        self.news = [News]()

        guard let items = self.items else { return }

        for newsBody in items {
            let ownerId = newsBody.sourceId

            if ownerId > 0 {
                let owner = users?.first(where: { $0.id == ownerId })
                self.news.append(News(owner, newsBody: newsBody))
            } else {
                let owner = groups?.first(where: { $0.id == -ownerId })
                self.news.append(News(owner, newsBody: newsBody))
            }
        }

        self.items = nil
        self.groups = nil
        self.users = nil
        self.nextFrom = nil

    }
}

// MARK: - News
class News {
    enum Kind: String {
        case text = "NewsText"
        case image = "NewsImage"
        case video = "NewsVideo"
        case audio = "NewsAudio"
        case textImage
        case textVideo
        case textAudio
        case imageVideo
        case imageAudio
        case videoAudio
        case textImageVideo
        case textImageAudio
        case textVideoAudio
        case imageVideoAudio
        case textImageVideoAudio

        var rawValue: [String] {
            switch self {
            case .text, .image, .video, .audio:
                return [self.rawValue]
            case .textImage:
                return [Kind.text.rawValue, Kind.image.rawValue]
            case .textVideo:
                return [Kind.text.rawValue, Kind.video.rawValue]
            case .textAudio:
                return [Kind.text.rawValue, Kind.audio.rawValue]
            case .imageVideo:
                return [Kind.image.rawValue, Kind.video.rawValue]
            case .imageAudio:
                return [Kind.image.rawValue, Kind.audio.rawValue]
            case .videoAudio:
                return [Kind.video.rawValue, Kind.audio.rawValue]
            case .textImageVideo:
                return [Kind.text.rawValue, Kind.image.rawValue, Kind.video.rawValue]
            case .textImageAudio:
                return [Kind.text.rawValue, Kind.image.rawValue, Kind.audio.rawValue]
            case .textVideoAudio:
                return [Kind.text.rawValue, Kind.video.rawValue, Kind.audio.rawValue]
            case .imageVideoAudio:
                return [Kind.image.rawValue, Kind.video.rawValue, Kind.audio.rawValue]
            case .textImageVideoAudio:
                return [Kind.text.rawValue, Kind.image.rawValue, Kind.video.rawValue, Kind.audio.rawValue]
            }
        }
    }

    let userOwner: User?
    let groupOwner: Group?
    var newsBody: NewsBody

    var postType: Kind? {
        let hasText = newsBody.text != nil
        let hasImage = newsBody.images.first != nil
        let hasVideo = newsBody.videos.first != nil
        let hasAudio = newsBody.audios.first != nil

        switch (hasText, hasImage, hasVideo, hasAudio) {
        case (true, false, false, false): return .text
        case (false, true, false, false): return .image
        case (false, false, true, false): return .video
        case (false, false, false, true): return .audio
        case (true, true, false, false): return .textImage
        case (true, false, true, false): return .textVideo
        case (true, false, false, true): return .textAudio
        case (false, true, true, false): return .imageVideo
        case (false, true, false, true): return .imageAudio
        case (false, false, true, true): return .videoAudio
        case (true, true, true, false): return .textImageVideo
        case (true, true, false, true): return .textImageAudio
        case (true, false, true, true): return .textVideoAudio
        case (false, true, true, true): return .imageVideoAudio
        case (true, true, true, true): return .textImageVideoAudio
        default: return nil
        }
    }

    init(_ user: User?, newsBody: NewsBody) {
        self.userOwner = user
        self.newsBody = newsBody
        self.groupOwner = nil
    }

    init(_ group: Group?, newsBody: NewsBody) {
        self.groupOwner = group
        self.newsBody = newsBody
        self.userOwner = nil
    }
}

// MARK: - NewsCellTypeDataProtocol
extension News: NewsCellTypeDataProtocol {}
