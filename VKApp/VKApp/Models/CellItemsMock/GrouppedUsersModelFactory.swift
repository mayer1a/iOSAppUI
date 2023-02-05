//
//  UserCellModelFactory.swift
//  VKApp
//
//  Created by Artem Mayer on 11.01.2023.
//

import Foundation

struct GrouppedUsersModelFactory {

    // MARK: - Functions
    
    func construct(from usersModel: [User]) -> [GrouppedFriends] {
        var result: [GrouppedFriends] = []
        let usersModel = usersModel.sorted { $0.lastName < $1.lastName }

        usersModel.forEach { user in
            guard let character: Character = user.lastName.first else { return }

            if let currentCharacter = result.firstIndex(where: { $0.character == character }) {
                result[currentCharacter].users.append(user)
            } else {
                result.append(GrouppedFriends(character: character, users: [user]))
            }
        }

        return result
    }
}
