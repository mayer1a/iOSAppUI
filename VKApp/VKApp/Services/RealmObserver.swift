//
//  RealmObserver.swift
//  VKApp
//
//  Created by Artem Mayer on 29.05.2022.
//

import Foundation
import RealmSwift


class RealmObserver {

    static let shared = RealmObserver()

    func makeObserver<T>(_: T.Type,
                         completion: @escaping (NotificationToken, [T]?, (IndexSet,IndexSet,IndexSet)?) -> Void) where T: Object {

        let realmObjects: Results<T>
        var objects: [T] = []
        var deletionIndexSet = IndexSet()
        var insertionIndexSet = IndexSet()
        var modificationIndexSet = IndexSet()

        guard let realm = try? Realm() else { return }

        realmObjects = realm.objects(T.self)

        let realmNotification = realmObjects.observe { changes in

            switch changes {
            case let .initial(realmObjects):
                objects = Array(realmObjects)

            case let .update(obj, deletions, insertions, modifications):
                objects = Array(obj)

                deletionIndexSet = deletions.reduce(into: IndexSet(), { $0.insert($1) })
                insertionIndexSet = insertions.reduce(into: IndexSet(), { $0.insert($1) })
                modificationIndexSet = modifications.reduce(into: IndexSet(), { $0.insert($1) })

            case .error(let error):
                print(error)
            }
        }

        completion(realmNotification, objects, (deletionIndexSet, insertionIndexSet, modificationIndexSet))
    }
}
