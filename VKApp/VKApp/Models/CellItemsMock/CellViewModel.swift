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

// MARK: - GrouppedUserModel

struct GrouppedUserModel: Identifiable {
    var id: Character
    var users: [CellViewModel]
}
