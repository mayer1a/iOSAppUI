//
//  GrouppedFriends.swift
//  VKApp
//
//  Created by Artem Mayer on 08.04.2022.
//

import Foundation

struct GrouppedFriends {
    var character: Character
    var users: [User]

    static var list: [GrouppedFriends] = [GrouppedFriends(character: Character(" "),
                                                          users: User.friends)]
}
