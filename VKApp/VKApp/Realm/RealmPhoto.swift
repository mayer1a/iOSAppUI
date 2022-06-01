//
//  RealmPhoto.swift
//  VKApp
//
//  Created by Artem Mayer on 15.05.2022.
//

import Foundation
import RealmSwift


class RealmPhoto: Object {
    @Persisted(primaryKey: true)
    var id: Int

    @Persisted
    var albumId: Int

    @Persisted
    var ownerId: Int

    @Persisted
    var smallSizeUrl: String

    @Persisted
    var originalSizeUrl: String?

    @Persisted
    var likesCounter: Int

    @Persisted
    var isLiked: Int


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

            return realmPhoto
        }

        do {
            let realm = try Realm()

            try realm.write {
                realm.delete(realm.objects(RealmPhoto.self).filter { $0.id == ownerId } )
                realmPhotos.forEach { realm.add($0) }
            }
        } catch {
            print(error)
        }
    }


    // MARK: - deleteOutdatedData

    static func deleteData(by id: Int) throws {

        guard
            let realm = try? Realm(),
            let objectForDelete = realm.objects(RealmPhoto.self).first(where: { $0.id == id })
        else {
            return
        }

        try realm.write {
            realm.delete(objectForDelete)
        }
    }


    // MARK: - restoreData

    static func restoreData(userId: Int) throws -> [Photo] {
        let realm = try Realm()
        let objects = realm.objects(RealmPhoto.self).filter { $0.ownerId == userId }

        let photo = Array(objects
            .map {
                Photo(id: $0.id,
                      albumId: $0.albumId,
                      ownerId: $0.ownerId,
                      smallSizeUrl: $0.smallSizeUrl,
                      originalSizeUrl: $0.originalSizeUrl,
                      likesCounter: $0.likesCounter,
                      isLiked: $0.isLiked)
            })

        return photo
    }
}
