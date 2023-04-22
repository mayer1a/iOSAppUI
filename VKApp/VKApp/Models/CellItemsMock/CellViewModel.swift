//
//  CellViewModel.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import Foundation

// MARK: - CellViewModel

struct CellViewModel: Identifiable {
    let id: Int
    let fullName: String
    let avatar: URL?
}

// MARK: - CellViewModelFactory

struct CellViewModelFactory {

    // MARK: - Functions

    func construct(_ users: [User]) -> [CellViewModel] {
        let viewModel: [CellViewModel] = users.compactMap { user in
            let fullName = "\(user.firstName) \(user.lastName)"
            let avatarUrl = URL(string: user.avatar)

            return CellViewModel(id: user.id, fullName: fullName, avatar: avatarUrl)
        }

        return viewModel
    }
}
