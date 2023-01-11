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

// MARK: - UserCellModelFactory

final class UserCellModelFactory {

    // MARK: - Functions
    
    func construct(from userModel: User) -> CellViewModel {
        let fullName = "\(userModel.firstName) \(userModel.lastName)"
        let avatarUrl = URL(string: userModel.avatar)

        return CellViewModel(id: userModel.id,
                             fullName: fullName,
                             avatar: avatarUrl)
    }
}
