//
//  RealmUser.swift
//  VKApp
//
//  Created by Artem Mayer on 15.05.2022.
//

import Foundation
import RealmSwift


class RealmUser: Object {
    @Persisted(primaryKey: true)
    var id: Int

    @Persisted
    var firstName: String

    @Persisted
    var lastName: String

    @Persisted
    var isClosed: Bool?

    @Persisted
    var canAccessClosed: Bool?

    @Persisted
    var avatar: String

    @Persisted
    var blacklisted: Int?

    @Persisted
    var isFriend: Int?


    // MARK: - saveData

    static func saveData(data users: [User]) {

        let realmUsers: [RealmUser] = users
            .map { user in
                let realmUser = RealmUser()

                realmUser.id = user.id
                realmUser.firstName = user.firstName
                realmUser.lastName = user.lastName
                realmUser.isClosed = user.isClosed
                realmUser.canAccessClosed = user.canAccessClosed
                realmUser.avatar = user.avatar
                realmUser.blacklisted = user.blacklisted
                realmUser.isFriend = user.isFriend

                return realmUser }
            .sorted { $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedAscending }

        do {
            let realm = try Realm()

            try realm.write {
                realm.delete(realm.objects(RealmUser.self))
                realmUsers.forEach { realm.add($0) }
            }
        } catch {
            print(error)
        }
    }


    // MARK: - deleteOutdatedData

    static func deleteData(by id: Int) throws {

        guard
            let realm = try? Realm(),
            let objectForDelete = realm.objects(RealmUser.self).first(where: { $0.id == id })
        else {
            return
        }
        
        try realm.write {
            realm.delete(objectForDelete)
        }
    }


    // MARK: - restoreData

    static func restoreData() throws -> [User] {
        let realm = try Realm()
        let objects = realm.objects(RealmUser.self)

        let users = Array(objects.map {
            User(id: $0.id,
                 firstName: $0.firstName,
                 lastName: $0.lastName,
                 isClosed: $0.isClosed,
                 canAccessClosed: $0.canAccessClosed,
                 avatar: $0.avatar,
                 blacklisted: $0.blacklisted,
                 isFriend: $0.isFriend)
        })

        return users
    }
    
}
