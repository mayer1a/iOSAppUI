//
//  FriendsScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 11.01.2023.
//

import SwiftUI

struct FriendsScreen: View {

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Друзья", image: .init("friendsIconsSet"))
                }

            GroupsScreen()
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

private struct ContentView: View {

    // MARK: - State properties

    @State private var cellModel: [GrouppedUserModel] = {
        let cellModelFactory = UserCellModelFactory()

        let users = UserMockModel.shared.users

        return cellModelFactory.construct(from: users)
    }()

    // MARK: - Private properties

    private let cellModelFactory = UserCellModelFactory()

    var body: some View {
        NavigationView {
            List {
                ForEach(cellModel) { section in
                    Section {
                        ForEach(section.users) { user in
                            NavigationLink {
                                FriendsPhotosScreen(photosCount: Int.random(in: 1..<7))
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
            .navigationTitle("Друзья")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}
