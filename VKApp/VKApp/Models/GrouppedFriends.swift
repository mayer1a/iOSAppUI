//
//  GrouppedFriends.swift
//  VKApp
//
//  Created by Artem Mayer on 08.04.2022.
//

import Foundation

// MARK: - GrouppedFriends

struct GrouppedFriends: Identifiable {
    typealias ID = Character

    var id: Character {
        return character
    }

    var character: Character
    var users: [User]
}
