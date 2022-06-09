//
//  ChangesIndexesCalculating.swift
//  VKApp
//
//  Created by Artem Mayer on 09.06.2022.
//

import Foundation
import RealmSwift


final class IndexCalculator {

    private init() {}
    
    static func getIndexes(from: [User]?, in objects: [GrouppedFriends], with changes: [Int]) -> [IndexPath] {

        guard let from = from else { return [IndexPath]() }

        var indexPaths = [IndexPath]()

        changes.forEach { element in

            guard let firstLastNameChar = from[element].lastName.first else { return }

            let section = objects
                .enumerated()
                .first { $0.element.character == Character(firstLastNameChar.uppercased()) }?
                .offset

            guard let section = section else { return }

            let row = objects[section]
                .users
                .enumerated()
                .first { $0.element.id == from[element].id }?
                .offset

            guard let row = row else { return }

            indexPaths.append(IndexPath(row: row, section: section))
        }

        return indexPaths
    }
}
