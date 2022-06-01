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
                         completion: @escaping () -> Void) -> NotificationToken? where T: Object {

        let realmObjects: Results<T>

        guard let realm = try? Realm() else { return nil }

        realmObjects = realm.objects(T.self)

        let realmNotification = realmObjects.observe { changes in

            switch changes {
            case .initial(_), .update(_,_,_,_):
                completion()

            case .error(let error):
                print(error)
            }
        }

        return realmNotification
    }
}
