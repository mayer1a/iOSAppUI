//
//  FriendsScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 11.01.2023.
//

import SwiftUI

// MARK: - FriendsScreen

struct FriendsScreen: View {

    // MARK: - Properties

    var body: some View {
        TabView {
            ContentView(viewModel: FriendsViewModel(networkService: NetworkService()))
                .tabItem {
                    Label("Друзья", image: .init("friendsIconsSet"))
                }

            GroupsScreen(viewModel: GroupsViewModel(getGroupsPromise: GetUserGroups()))
                .tabItem {
                    Label("Группы", image: .init("communityIconsSet"))
                }

            NewsScreen()
                .tabItem {
                    Label("Новости", image: .init("news"))
                }
        }
    }
}

// MARK: - ContentView

private struct ContentView: View {

    // MARK: - Observed properties

    @ObservedObject var viewModel: FriendsViewModel

    // MARK: - Private properties

    private let cellViewModelFactory = CellViewModelFactory()

    // MARK: - Constructions

    init(viewModel: FriendsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Properties

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.friends) { section in
                    let usersViewModel = cellViewModelFactory.construct(section.users)

                    Section {
                        ForEach(usersViewModel) { user in
                            NavigationLink {
                                let viewModel = UserPhotoViewModel(id: user.id,
                                                                   networkService: NetworkService())
                                
                                FriendsPhotosScreen(viewModel: viewModel)
                            } label: {
                                Cell(model: user)
                            }
                        }
                    } header: {
                        Text(String(section.id))
                    }
                }
            }
            .listStyle(.grouped)
            .navigationBarBackButtonHidden()
            .navigationBarTitle("Друзья", displayMode: .inline)
            .onAppear(perform: viewModel.fetchFriends)
        }
    }
}
