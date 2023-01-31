//
//  UserPhotoViewModel.swift
//  VKApp
//
//  Created by Artem Mayer on 31.01.2023.
//

import Foundation
import RealmSwift

final class UserPhotoViewModel: ObservableObject {

    // MARK: - Properties

    let objectWillChange = ObjectWillChangePublisher()

    var detachedPhotos: [Photo] {
        let detached = (photos?.map { $0.detached() }) ?? []

        return RealmPhoto.realmToPhoto(from: detached)
    }

    // MARK: - Private properties

    let id: Int
    let networkService: NetworkServiceInterface

    private var notificationToken: NotificationToken?

    private lazy var photos: Results<RealmPhoto>? = try? RealmPhoto.getData(ownerId: self.id)

    // MARK: - Constructions

    init(id: Int, networkService: NetworkServiceInterface) {
        self.id = id
        self.networkService = networkService

        changesSubscribe()
    }

    // MARK: - Functions

    func fetchPhotos() {
        networkService.getPhotos(id: self.id) { [weak self] photos in
            if let id = self?.id {
                RealmPhoto.saveData(data: photos, for: id)
            }
        }
    }

    // MARK: - Private functions

    private func changesSubscribe() {
        notificationToken = photos?.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

}

// MARK: - Extensions

extension UserPhotoViewModel: Identifiable {
    typealias ID = Int
}
