//
//  RealmGroup.swift
//  VKApp
//
//  Created by Artem Mayer on 15.05.2022.
//

import Foundation
import RealmSwift


class RealmGroup: Object {
    @Persisted(primaryKey: true)
    var id: Int

    @Persisted
    var name: String

    @Persisted
    var isMember: Int?

    @Persisted
    var avatar: String

    @Persisted
    var isClosed: Int


    // MARK: - saveData

    static func saveData(data groups: [Group]) {

        let realmGroups: [RealmGroup] = groups.map { group in
            let realmGroup = RealmGroup()

            realmGroup.id = group.id
            realmGroup.name = group.name
            realmGroup.isMember = group.isMember
            realmGroup.avatar = group.avatar
            realmGroup.isClosed = group.isClosed

            return realmGroup
        }

        do {
            let realm = try Realm()

            try realm.write {
                realmGroups.forEach { realm.add($0) }
            }
        } catch {
            print(error)
        }
    }


    // MARK: - restoreData

    static func restoreData() throws -> [Group] {
        let realm = try Realm()
        let objects = realm.objects(RealmGroup.self)

        let group = Array(objects.map {
            Group(id: $0.id,
                 name: $0.name,
                 isMember: $0.isMember,
                 avatar: $0.avatar,
                 isClosed: $0.isClosed)
        })

        return group
    }
}
