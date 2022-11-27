//
//  RealmPhoto.swift
//  VKApp
//
//  Created by Artem Mayer on 15.05.2022.
//

import Foundation
import RealmSwift

// MARK: - RealmPhoto
final class RealmPhoto: Object {
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var albumId: Int
    
    @Persisted
    var ownerId: Int
    
    @Persisted
    var smallSizeUrl: String?
    
    @Persisted
    var originalSizeUrl: String?
    
    @Persisted
    var likesCounter: Int?
    
    @Persisted
    var isLiked: Bool?

    @Persisted
    var aspectRatio: Double?

    @Persisted
    var repostsCount: Int?

    @Persisted
    var isReposted: Bool?

    @Persisted
    var canRepost: Bool?

    @Persisted
    var commentsCount: Int?

    @Persisted
    var canComment: Bool?

    @Persisted
    var text: String?
    
    // MARK: - saveData
    static func saveData(data photos: [Photo], for ownerId: Int) {
        let realmPhotos: [RealmPhoto] = photos.map { photo in
            let realmPhoto = RealmPhoto()
            
            realmPhoto.id = photo.id
            realmPhoto.albumId = photo.albumId
            realmPhoto.ownerId = photo.ownerId
            realmPhoto.smallSizeUrl = photo.smallSizeUrl
            realmPhoto.originalSizeUrl = photo.originalSizeUrl
            realmPhoto.likesCounter = photo.likesCounter
            realmPhoto.isLiked = photo.isLiked
            realmPhoto.aspectRatio = photo.aspectRatio
            realmPhoto.repostsCount = photo.repostsCount
            realmPhoto.isReposted = photo.isReposted
            realmPhoto.canRepost = photo.canRepost
            realmPhoto.commentsCount = photo.commentsCount
            realmPhoto.canComment = photo.canComment
            realmPhoto.text = photo.text
            
            return realmPhoto
        }
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realmPhotos.forEach { realm.add($0) }
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - deleteData
    static func deleteData(by ownerId: Int) throws {
        guard let realm = try? Realm() else { return }
        
        let objectForDelete = realm.objects(RealmPhoto.self).filter { $0.ownerId == ownerId }
        
        try realm.write {
            realm.delete(objectForDelete)
        }
    }
    
    // MARK: - restoreData
    static func restoreData(ownerId: Int) throws -> [RealmPhoto] {
        let realm = try Realm()
        let objects = realm
            .objects(RealmPhoto.self)
            .filter { $0.ownerId == ownerId }
        
        return Array(objects)
    }
    
    // MARK: - realmToPhoto
    static func realmToPhoto(from objects: [RealmPhoto], by ownerId: Int? = nil) -> [Photo] {
        let photo = objects
            .map {
                Photo(id: $0.id,
                      albumId: $0.albumId,
                      ownerId: $0.ownerId,
                      smallSizeUrl: $0.smallSizeUrl,
                      originalSizeUrl: $0.originalSizeUrl,
                      aspectRatio: $0.aspectRatio,
                      likesCounter: $0.likesCounter,
                      isLiked: $0.isLiked,
                      repostsCount: $0.repostsCount,
                      isReposted: $0.isReposted,
                      canRepost: $0.canRepost,
                      commentsCount: $0.commentsCount,
                      canComment: $0.canComment,
                      text: $0.text)
            }
        
        return photo
    }
}
