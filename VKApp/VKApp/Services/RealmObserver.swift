//
//  RealmObserver.swift
//  VKApp
//
//  Created by Artem Mayer on 29.05.2022.
//

import Foundation
import RealmSwift

// MARK: - RealmObserver
final class RealmObserver {
    static let shared = RealmObserver()
    
    // MARK: - makeObserver
    func makeObserver<T: Object>(ownerId: Int? = nil,
                                 completion: @escaping ([T], ([Int], [Int], [Int])?) -> Void) -> NotificationToken?
    {
        var realmObjects: Results<T>
        
        guard let realm = try? Realm() else { return nil }
        
        realmObjects = realm.objects(T.self)
        
        if T.self is RealmPhoto.Type,
           let ownerId = ownerId,
           let filteredObjects = (realm.objects(T.self) as? Results<RealmPhoto>)?.where({ $0.ownerId == ownerId }),
           let realmFilteredObjects = filteredObjects as? Results<T>
        {
            realmObjects = realmFilteredObjects
        }
        
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
