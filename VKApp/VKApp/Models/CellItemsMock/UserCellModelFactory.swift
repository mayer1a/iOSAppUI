//
//  UserCellModelFactory.swift
//  VKApp
//
//  Created by Artem Mayer on 11.01.2023.
//

import SwiftUI

// MARK: - CellViewModel

struct CellViewModel: Identifiable {
    let id: Int
    let fullName: String
    let avatar: URL?
}

// MARK: - GrouppedUserModel

struct GrouppedUserModel: Identifiable {
    var id: Character
    var users: [CellViewModel]
}

// MARK: - UserCellModelFactory

final class UserCellModelFactory {

    // MARK: - Functions
    
    func construct(from usersModel: [User]) -> [GrouppedUserModel] {
        var result: [GrouppedUserModel] = []
        let usersModel = usersModel.sorted { $0.lastName < $1.lastName }

        usersModel.forEach { user in
            guard let character: Character = user.lastName.first else { return }

            if let currentCharacter = result.firstIndex(where: { $0.id == character }) {
                result[currentCharacter].users.append(userToCellModel(user))
            } else {
                result.append(GrouppedUserModel(id: character,
                                                users: [userToCellModel(user)]))
            }
        }

        return result
    }

    // MARK: - Private Functions

    private func userToCellModel(_ user: User) -> CellViewModel {
        let fullName = "\(user.firstName) \(user.lastName)"
        let avatarUrl = URL(string: user.avatar)

        return CellViewModel(id: user.id,
                             fullName: fullName,
                             avatar: avatarUrl)
    }
}
