//
//  FriendsAdapter.swift
//  VKApp
//
//  Created by Artem Mayer on 18.12.2022.
//

import UIKit
import RealmSwift

final class FriendsAdapter {

    // MARK: - Private properties

    private let operationQueue = OperationQueue()
    private var realmNotificationTokens: [String : NotificationToken] = [:]

    // MARK: - Functions

    func getFriends(_ completion: @escaping ([User], ([Int], [Int], [Int])?) -> Void) {
        guard let realm = try? Realm() else { return }

        let realmUser = realm.objects(RealmUser.self)

        realmNotificationTokens["friends"]?.invalidate()

        let token = realmUser.observe() { [weak self] changes in
            guard let self = self else { return }

            switch changes {
                case .initial(let realmUsers):
                var friends: [User] = []

                for realmUser in realmUsers {
                    friends.append(self.realmUsersToUsers(realmUser))
                }

                completion(friends, nil)
                case .update(let realmUsers, let deletions, let insertions, let modifications):
                    var friends: [User] = []

                    for realmUser in realmUsers {
                        friends.append(self.realmUsersToUsers(realmUser))
                    }

                    self.realmNotificationTokens["friends"]?.invalidate()

                    completion(friends, (deletions, insertions, modifications))
                case .error(let error):
                    print(error)
            }
        }

        realmNotificationTokens["friends"] = token

        do {
            let realmUsers = try RealmUser.restoreData()
            let userDefaults = UserDefaults.standard
            let currentTime = Int(Date().timeIntervalSince1970)
            
            if currentTime - userDefaults.integer(forKey: "friendsLastLoad") > 10_000 || realmUsers.isEmpty {

                let request = SessionHelper.shared.getFriendsRequest
                let fetchDataOperation = FetchDataOperation(request: request)
                let asyncParseOperation = AsyncParseDataOperation<User>()
                let saveRealmOperation = SaveRealmOperation<User>()

                asyncParseOperation.addDependency(fetchDataOperation)
                saveRealmOperation.addDependency(asyncParseOperation)

                operationQueue.qualityOfService = .userInteractive
                operationQueue.addOperation(fetchDataOperation)
                operationQueue.addOperation(asyncParseOperation)
                operationQueue.addOperation(saveRealmOperation)
            } else {

                var friends: [User] = []

                for realmUser in realmUsers {
                    friends.append(self.realmUsersToUsers(realmUser))
                }

                completion(friends, nil)
            }

            userDefaults.set(currentTime, forKey: "friendsLastLoad")
        } catch {
            print("errorrrrrrr: \(error)")
        }

    }

    // MARK: - Private functions

    private func realmUsersToUsers(_ realmUsers: RealmUser) -> User {
        return User(id: realmUsers.id,
                    firstName: realmUsers.firstName,
                    lastName: realmUsers.lastName,
                    isClosed: realmUsers.isClosed,
                    canAccessClosed: realmUsers.canAccessClosed,
                    avatar: realmUsers.avatar,
                    blacklisted: realmUsers.blacklisted,
                    isFriend: realmUsers.isFriend)
    }
}
