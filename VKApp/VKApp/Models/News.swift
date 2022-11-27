//
//  News.swift
//  VKApp
//
//  Created by Artem Mayer on 29.08.22.
//

import UIKit

// MARK: - NewsBody
final class NewsBody: Decodable {
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case isFavorite = "is_favorite"
        case markedAsAds = "marked_as_ads"
        case postSource = "post_source"
        case postId = "post_id"
        case signerId = "signer_id"
        case topicId = "topic_id"
        case date
        case text
        case reposts
        case comments
        case likes
        case views
        case isViewed
        case attachments
        case type
        case photos
        case videos
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
        case video
    }

    enum WallPhotosKeys: String, CodingKey {
        case items
    }

    enum VideoKeys: String, CodingKey {
        case items
    }

    enum NewsType: String {
        case post
        case photo
        case wallPhoto = "wall_photo"
        case musicVideo = "music_video"
        case video
        case movie
    }
    
    var sourceId: Int?
    var date: TimeInterval?
    var postId: Int?
    var markedAsAds: Int?
    var signerId: Int?
    var topicId: Int?
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
    var isViewed: Bool = false
    var images: [Photo?]
    var audios: [String?]
    var videos: [Video?]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        self.images = [Photo]()
        self.audios = [String?]()
        self.videos = [Video?]()

        switch type {
            case NewsType.post.rawValue:
                try self.postParse(from: container)
            case NewsType.photo.rawValue, NewsType.wallPhoto.rawValue:
                try self.photoParse(from: container)
            case NewsType.video.rawValue, NewsType.musicVideo.rawValue, NewsType.movie.rawValue:
                try self.videoParse(from: container)
            default:
                break
        }
    }

    // MARK: - postParse
    private func postParse(from container: KeyedDecodingContainer<NewsBody.CodingKeys>) throws {
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)
        self.date = try container.decode(TimeInterval.self, forKey: .date)
        self.postId = try? container.decode(Int.self, forKey: .postId)

        self.canDoubtCategory = try? container.decode(Bool.self, forKey: .canDoubtCategory)
        self.canSetCategory = try? container.decode(Bool.self, forKey: .canSetCategory)
        self.isFavorite = try? container.decode(Bool.self, forKey: .isFavorite)
        self.markedAsAds = try? container.decode(Int.self, forKey: .markedAsAds)

        self.signerId = try? container.decode(Int.self, forKey: .signerId)
        self.topicId = try? container.decode(Int.self, forKey: .topicId)
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

        var nestedUnkeyedMediaContainer = try? container.nestedUnkeyedContainer(forKey: .attachments)

        while !(nestedUnkeyedMediaContainer?.isAtEnd ?? true) {
            let nestedMediaContainer = try? nestedUnkeyedMediaContainer?.nestedContainer(keyedBy: AttachmentsKeys.self)
            let attachmentType = try? nestedMediaContainer?.decode(String.self, forKey: .type)

            switch attachmentType {
                case NewsType.post.rawValue, NewsType.photo.rawValue, NewsType.wallPhoto.rawValue:
                    self.photoParse(from: nestedMediaContainer)
                case NewsType.video.rawValue, NewsType.musicVideo.rawValue, NewsType.movie.rawValue:
                    self.videoParse(from: nestedMediaContainer)
                default: break
            }
        }
    }

    // MARK: - photoParse
    private func photoParse(from container: KeyedDecodingContainer<NewsBody.CodingKeys>) throws {
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)
        self.date = try container.decode(TimeInterval.self, forKey: .date)
        self.postId = try? container.decode(Int.self, forKey: .postId)

        let nestedImageContainer = try? container.nestedContainer(keyedBy: WallPhotosKeys.self, forKey: .photos)

        let image = try? nestedImageContainer?.decode(Photo.self, forKey: .items)
        self.images.append(image)
    }

    // MARK: - photoParse
    private func photoParse(from container: KeyedDecodingContainer<NewsBody.AttachmentsKeys>?) {
        if !self.images.isEmpty { return }
        let image = try? container?.decode(Photo.self, forKey: .photo)
        self.images.append(image)
    }

    // MARK: - videoParse
    private func videoParse(from container: KeyedDecodingContainer<NewsBody.CodingKeys>) throws {
        self.sourceId = try container.decode(Int.self, forKey: .sourceId)
        self.date = try container.decode(TimeInterval.self, forKey: .date)
        self.postId = try? container.decode(Int.self, forKey: .postId)

        let nestedImageContainer = try? container.nestedContainer(keyedBy: VideoKeys.self, forKey: .videos)
        let video = try? nestedImageContainer?.decode(Video.self, forKey: .items)
        self.videos.append(video)
    }

    // MARK: - videoParse
    private func videoParse(from container: KeyedDecodingContainer<NewsBody.AttachmentsKeys>?) {
        if !self.videos.isEmpty { return }
        let video = try? container?.decode(Video.self, forKey: .video)
        self.videos.append(video)
    }
}

// MARK: - NewsResponse
final class NewsResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    enum RequestKeys: String, CodingKey {
        case items
        case users = "profiles"
        case groups
        case nextFrom = "next_from"
    }
    
    var nextFrom: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseValue = try container.nestedContainer(keyedBy: RequestKeys.self, forKey: .response)
        
        self.nextFrom = try? responseValue.decode(String.self, forKey: .nextFrom)

        UserDefaults.standard.set(self.nextFrom, forKey: "newsNextFrom")
    }
    
    func parseData(data: Data, completion: @escaping ([News]) -> Void) {
        DispatchQueue.global().async {
            var newsBodies = [NewsBody]()
            var newsGroups = [Group]()
            var newsUsers = [User]()
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            dispatchGroup.enter()
            dispatchGroup.enter()
            
            let jsonObject = (try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                              as? [String : Any]
            ) ?? [:]
            
            let response = (jsonObject["response"] as? [String : Any]) ?? [:]
            let items = response["items"]
            let groups = response["groups"]
            let users = response["profiles"]
            
            let itemsData = (try? JSONSerialization.data(withJSONObject: items as Any, options: .fragmentsAllowed)
            ) ?? Data()
            
            let profileData = (try? JSONSerialization.data(withJSONObject: users as Any, options: .fragmentsAllowed)
            ) ?? Data()
            
            let groupsData = (try? JSONSerialization.data(withJSONObject: groups as Any, options: .fragmentsAllowed)
            ) ?? Data()

            self.asyncParse(data: itemsData) { (model: [NewsBody]) in
                newsBodies = model
                dispatchGroup.leave()
            }
            
            self.asyncParse(data: profileData) { (model: [User]) in
                newsUsers = model
                dispatchGroup.leave()
            }
            
            self.asyncParse(data: groupsData) { (model: [Group]) in
                newsGroups = model
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .global()) {
                var news = [News]()

                newsBodies.forEach { newsBody in
                    if let ownerId = newsBody.sourceId {
                        if ownerId > 0 {
                            let owner = newsUsers.first(where: { $0.id == ownerId })
                            news.append(News(owner, newsBody: newsBody))
                        } else {
                            let owner = newsGroups.first(where: { $0.id == -ownerId })
                            news.append(News(owner, newsBody: newsBody))
                        }
                    }
                }

                news = news.compactMap { news in
                    if news.postType == .none {
                        return nil
                    } else {
                        return news
                    }
                }
                
                completion(news)
            }
        }
    }
    
    private func asyncParse<T: Decodable>(data: Data, completion: @escaping (T) -> Void) {
        DispatchQueue.global().async {
            if let parsedModel = try? JSONDecoder().decode(T.self, from: data) {
                completion(parsedModel)
            }
        }
    }
}

// MARK: - News
final class News {
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
        guard let isEmptyText = newsBody.text?.isEmpty else { return nil }

        let hasText = !isEmptyText
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
