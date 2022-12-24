//
//  FriendsPhotoAdapter.swift
//  VKApp
//
//  Created by Artem Mayer on 18.12.2022.
//

import UIKit
import RealmSwift

final class FriendsPhotoAdapter {

    // MARK: - Private properties

    private let operationQueue = OperationQueue()
    private var realmNotificationTokens: [String : NotificationToken] = [:]

    // MARK: - Functions

    func getPhotos(by userId: Int, _ completion: @escaping ([Photo], ([Int], [Int], [Int])?) -> Void) {
        guard let realm = try? Realm() else { return }

        let realmPhoto = realm.objects(RealmPhoto.self).where({ $0.ownerId == userId })

        realmNotificationTokens["photos"]?.invalidate()

        let token = realmPhoto.observe() { [weak self] changes in
            guard let self = self else { return }

            switch changes {
                case .initial(let realmPhotos):
                var photos: [Photo] = []

                for realmPhoto in realmPhotos {
                    photos.append(self.realmPhotosToPhotos(realmPhoto, by: userId))
                }

                completion(photos, nil)
                case .update(let realmPhotos, let deletions, let insertions, let modifications):
                    var photos: [Photo] = []

                    for realmPhoto in realmPhotos {
                        photos.append(self.realmPhotosToPhotos(realmPhoto, by: userId))
                    }

                    self.realmNotificationTokens["photos"]?.invalidate()

                    completion(photos, (deletions, insertions, modifications))
                case .error(let error):
                    print(error)
            }
        }

        realmNotificationTokens["photos"] = token

        do {
            let realmPhotos = try RealmPhoto.restoreData(ownerId: userId)

            if realmPhotos.isEmpty {
                let request = SessionHelper.shared.getPhotosRequest(id: userId)
                let fetchDataOperations = FetchDataOperation(request: request)
                let asyncParseOperation = AsyncParseDataOperation<Photo>()
                let saveRealmOperation = SaveRealmOperation<Photo>()

                asyncParseOperation.addDependency(fetchDataOperations)
                saveRealmOperation.addDependency(asyncParseOperation)

                operationQueue.qualityOfService = .userInteractive
                operationQueue.addOperation(fetchDataOperations)
                operationQueue.addOperation(asyncParseOperation)
                operationQueue.addOperation(saveRealmOperation)
            } else {
                var photos: [Photo] = []

                for realmPhoto in realmPhotos {
                    photos.append(self.realmPhotosToPhotos(realmPhoto, by: userId))
                }

                completion(photos, nil)
            }
        } catch {
            print(error)
        }
    }

    // MARK: - Private functions

    private func realmPhotosToPhotos(_ realmPhoto: RealmPhoto, by userId: Int) -> Photo {
        return Photo(id: realmPhoto.id,
                     albumId: realmPhoto.albumId,
                     ownerId: realmPhoto.ownerId,
                     smallSizeUrl: realmPhoto.smallSizeUrl,
                     originalSizeUrl: realmPhoto.originalSizeUrl,
                     aspectRatio: realmPhoto.aspectRatio,
                     likesCounter: realmPhoto.likesCounter,
                     isLiked: realmPhoto.isLiked,
                     repostsCount: realmPhoto.repostsCount,
                     isReposted: realmPhoto.isReposted,
                     canRepost: realmPhoto.canRepost,
                     commentsCount: realmPhoto.commentsCount,
                     canComment: realmPhoto.canComment,
                     text: realmPhoto.text)
    }
}

