//
//  Video.swift
//  VKApp
//
//  Created by Artem Mayer on 24.11.2022.
//

import Foundation

// MARK: - Video
final class Video: Decodable {
    enum CodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case firstFrame = "first_frame"
        case trackCode = "track_code"
        case accessKey = "access_key"
        case videoDescription = "description"
        case title
        case duration
        case image
        case date
        case id
        case height
        case width
        case views
    }

    let ownerID: Int
    let duration: Int
    let id: Int
    let width: Int?
    let height: Int?
    let date: TimeInterval
    let aspectRatio: Double
    let trackCode: String
    let accessKey: String
    var title: String
    var videoDescription: String?
    var pathToFile: String?
    var image: VideoImage?
    var firstFrame: VideoImage?
    var views: Int

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        var imageValues = try? container.nestedUnkeyedContainer(forKey: .image)
        var firstFrameValues = try? container.nestedUnkeyedContainer(forKey: .firstFrame)

        var images = [VideoImage?]()
        var firstFrames = [VideoImage?]()

        self.ownerID = try container.decode(Int.self, forKey: .ownerID)
        self.title = try container.decode(String.self, forKey: .title)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.views = try container.decode(Int.self, forKey: .views)
        self.date = try container.decode(TimeInterval.self, forKey: .date)
        self.id = try container.decode(Int.self, forKey: .id)
        self.width = try? container.decode(Int.self, forKey: .width)
        self.height = try? container.decode(Int.self, forKey: .height)
        self.trackCode = try container.decode(String.self, forKey: .trackCode)
        self.accessKey = try container.decode(String.self, forKey: .accessKey)
        self.videoDescription = try? container.decode(String.self, forKey: .videoDescription)
        self.aspectRatio = Double(self.height ?? 1) / Double(self.width ?? 1)

        while !(imageValues?.isAtEnd ?? true) {
            let imageValue = try? imageValues?.decode(VideoImage.self)
            images.append(imageValue)
        }

        while !(firstFrameValues?.isAtEnd ?? true) {
            let firstFrame = try? firstFrameValues?.decode(VideoImage.self)
            firstFrames.append(firstFrame)
        }

        let aspect = self.aspectRatio

        DispatchQueue.global().async { [weak self] in
            let frame = firstFrames.last(where: { $0?.aspectRatio == aspect }) ?? (firstFrames.last as? VideoImage)
            let image = images.last(where: { $0?.aspectRatio == aspect }) ?? (images.last as? VideoImage)

            if let frame = frame {
                DispatchQueue.main.async { [weak self] in
                    self?.firstFrame = frame
                }
            }

            if let image = image {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            }
        }
    }

    /// Init for the Realm
    required init(
        ownerID: Int,
        title: String,
        duration: Int,
        image: VideoImage,
        views: Int,
        firstFrame: VideoImage,
        date: TimeInterval,
        id: Int,
        height: Int,
        trackCode: String,
        width: Int,
        accessKey: String,
        videoDescription: String
    ) {
        self.ownerID = ownerID
        self.title = title
        self.duration = duration
        self.image = image
        self.views = views
        self.firstFrame = firstFrame
        self.date = date
        self.id = id
        self.height = height
        self.trackCode = trackCode
        self.width = width
        self.accessKey = accessKey
        self.videoDescription = videoDescription
        self.aspectRatio = Double(self.height ?? 1) / Double(self.width ?? 1)
    }
}

// MARK: - VideoImage
final class VideoImage: Decodable {
    enum ImageKeys: String, CodingKey {
        case withPadding = "with_padding"
        case url
        case width
        case height
    }

    let url: String
    let width: Int
    let height: Int
    let aspectRatio: Double
    var withPadding: Int?
    var cashImagePath: String?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImageKeys.self)

        self.url = try container.decode(String.self, forKey: .url)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.withPadding = try? container.decode(Int.self, forKey: .withPadding)
        self.aspectRatio = Double(self.height) / Double(self.width)
    }

    /// Init for the Realm
    required init(
        url: String,
        width: Int,
        height: Int,
        aspectRatio: Double,
        withPadding: Int?,
        cashImagePath: String?
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.withPadding = withPadding
        self.cashImagePath = cashImagePath
    }
}
