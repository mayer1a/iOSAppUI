//
//  FriendsViewModel.swift
//  VKApp
//
//  Created by Artem Mayer on 31.01.2023.
//

import Foundation

final class FriendsViewModel: ObservableObject {

    // MARK: - Observable properties

    @Published var friends: [GrouppedFriends] = []

    // MARK: - Private properties

    private let networkService: NetworkServiceInterface
    private let cellModelFactory = GrouppedUsersModelFactory()

    // MARK: - Constructions

    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }

    // MARK: - Functions

    func fetchFriends() {
        networkService.getFriends { [weak self] result in
            if let friends = self?.cellModelFactory.construct(from: result) {
                self?.friends = friends
            }
        }
    }
}
