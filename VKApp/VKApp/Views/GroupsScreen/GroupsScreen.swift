//
//  GroupsScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import SwiftUI

struct GroupsScreen: View {

    // MARK: - State Properties

    @State private var cellModel: [CellViewModel] = {
        let cellModelFactory = GroupCellModelFactory()

        let groups = GroupMockModel.shared.groups

        return cellModelFactory.construct(from: groups)
    }()

    // MARK: - Properties

    var body: some View {
        NavigationView {
            List(cellModel) { group in
                Cell(model: group)
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden()
            .navigationBarTitle("Группы", displayMode: .inline)
        }
    }
}
