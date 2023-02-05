//
//  GroupsScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import SwiftUI

struct GroupsScreen: View {

    // MARK: - Observed properties

    @ObservedObject private var viewModel: GroupsViewModel

    // MARK: - Private properties

    private let groupCellViewModelFactory = GroupCellModelFactory()

    // MARK: - Constructions
    
    init(viewModel: GroupsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Properties

    var body: some View {
        NavigationView {
            List(viewModel.detachedGroups, id: \.id) { group in
                let groupViewModel = groupCellViewModelFactory.construct(from: group)
                
                Cell(model: groupViewModel)
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden()
            .navigationBarTitle("Группы", displayMode: .inline)
            .onAppear(perform: viewModel.fetchGroups)
        }
    }
}
