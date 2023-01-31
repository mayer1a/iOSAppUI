//
//  RealmSwift+Extensions.swift
//  VKApp
//
//  Created by Artem Mayer on 31.01.2023.
//

import RealmSwift

extension Realm.Configuration {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
}
