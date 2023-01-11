//
//  FriendsScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 11.01.2023.
//

import SwiftUI

struct FriendsScreen: View {

    @State private var cellModel: [CellViewModel] = {
        let cellModelFactory = UserCellModelFactory()

        return UserMockModel.shared.users.map {
            cellModelFactory.construct(from: $0)
        }
    }()
    
    // MARK: - Private properties

    private let cellModelFactory = UserCellModelFactory()

    var body: some View {
        List(cellModel) { friend in
            Cell(model: friend)
        }
        .listStyle(.grouped)
        .navigationBarTitle("Друзья", displayMode: .inline)
    }
}

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsScreen()
    }
}
