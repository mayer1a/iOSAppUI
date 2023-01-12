//
//  FriendsScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 11.01.2023.
//

import SwiftUI

struct FriendsScreen: View {

    // MARK: - State properties
    
    @State private var cellModel: [GrouppedUserModel] = {
        let cellModelFactory = UserCellModelFactory()

        let users = UserMockModel.shared.users

        return cellModelFactory.construct(from: users)
    }()
    
    // MARK: - Private properties

    private let cellModelFactory = UserCellModelFactory()

    var body: some View {
        List {
            ForEach(cellModel) { section in
                Section {
                    ForEach(section.users) { user in
                        Cell(model: user)
                    }
                } header: {
                    Text(String(section.id))
                }
            }
        }
        .listStyle(.grouped)
        .navigationBarTitle("Друзья", displayMode: .inline)
        .navigationBarBackButtonHidden()
    }
}
