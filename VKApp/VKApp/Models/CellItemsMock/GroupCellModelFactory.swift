//
//  GroupCellModelFactory.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import Foundation

struct GroupCellModelFactory {

    // MARK: - Functions

    func construct(from groupsModel: [Group]) -> [CellViewModel] {
        return groupsModel.map { userToCellModel($0) }
    }

    // MARK: - Private Functions

    private func userToCellModel(_ group: Group) -> CellViewModel {
        let avatarUrl = URL(string: group.avatar)

        return CellViewModel(id: group.id,
                             fullName: group.name,
                             avatar: avatarUrl)
    }
}
