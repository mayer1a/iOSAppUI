//
//  RealmGroup.swift
//  VKApp
//
//  Created by Artem Mayer on 15.05.2022.
//

import Foundation
import RealmSwift

// MARK: - RealmGroup
final class RealmGroup: Object {
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
            let realm = try Realm(configuration: .deleteIfMigration)

            try realm.write {
                realm.delete(realm.objects(RealmGroup.self))
                realmGroups.forEach { realm.add($0, update: .modified) }
            }
        } catch {
            print(error)
        }
    }

    // MARK: - deleteOutdatedData
    static func deleteData(by id: Int) throws {
        guard
            let realm = try? Realm(configuration: .deleteIfMigration),
            let objectForDelete = realm.objects(RealmGroup.self).first(where: { $0.id == id })
        else { return }

        try realm.write {
            realm.delete(objectForDelete)
        }
    }

    // MARK: - restoreData
    static func restoreData() throws -> [RealmGroup] {
        let realm = try Realm(configuration: .deleteIfMigration)
        let objects = realm.objects(RealmGroup.self)

        return Array(objects)
    }

    // MARK: - getData

    static func getData() throws -> Results<RealmGroup>? {
        let realm = try Realm(configuration: .deleteIfMigration)
        let objects = realm.objects(RealmGroup.self)

        return objects
    }

    // MARK: - realmToGroup
    static func realmToGroup(from objects: [RealmGroup]) -> [Group] {
        let group = objects.map {
            Group(id: $0.id,
                  name: $0.name,
                  isMember: $0.isMember,
                  avatar: $0.avatar,
                  isClosed: $0.isClosed)}

        return Array(group)
    }
}
