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
                         completion: @escaping ([T], ([Int], [Int], [Int])?) -> ()) -> NotificationToken? where T: Object {

        let realmObjects: Results<T>

        guard let realm = try? Realm() else { return nil }

        realmObjects = realm.objects(T.self)

        let realmNotification = realmObjects.observe { changes in

            switch changes {
            case let .initial(objects):
                completion(Array(objects), nil)

            case let .update(objects, deletions, insertions, modifications):
                completion(Array(objects), (deletions, insertions, modifications))

            case .error(let error):
                print(error)
            }
        }

        return realmNotification
    }
}
