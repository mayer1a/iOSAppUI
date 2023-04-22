//
//  GroupCellModelFactory.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import Foundation

struct GroupCellModelFactory {

    // MARK: - Functions

    func construct(from groupModel: Community) -> CellViewModel {
        let avatarUrl = URL(string: groupModel.avatar)

        return CellViewModel(id: groupModel.id,
                             fullName: groupModel.name,
                             avatar: avatarUrl)
    }
}
