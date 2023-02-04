//
//  GroupsAdapter.swift
//  VKApp
//
//  Created by Artem Mayer on 18.12.2022.
//

import UIKit
import RealmSwift
import PromiseKit

final class GroupsAdapter {

    // MARK: - Private properties

    private let getGroupsPromise = GetUserGroups()
    private var realmNotificationTokens: [String : NotificationToken] = [:]

    // MARK: - Functions

    func getGroups(_ completion: @escaping ([Community], ([Int], [Int], [Int])?) -> Void) {
        guard let realm = try? Realm() else { return }

        let realmGroups = realm.objects(RealmGroup.self)

        realmNotificationTokens["groups"]?.invalidate()

        let token = realmGroups.observe() { [weak self] changes in
            guard let self = self else { return }

            switch changes {
                case .initial(let realmGroups):
                var groups: [Community] = []

                for realmGroup in realmGroups {
                    groups.append(self.realmGroupsToGroups(realmGroup))
                }

                completion(groups, nil)
                case .update(let realmGroups, let deletions, let insertions, let modifications):
                    var groups: [Community] = []

                    for realmGroup in realmGroups {
                        groups.append(self.realmGroupsToGroups(realmGroup))
                    }

                    self.realmNotificationTokens["groups"]?.invalidate()

                    completion(groups, (deletions, insertions, modifications))
                case .error(let error):
                    print(error)
            }
        }

        realmNotificationTokens["groups"] = token

        let userDefaults = UserDefaults.standard
        let currentTime = Int(Date().timeIntervalSince1970)

        do {
            let realmGroups = try RealmGroup.restoreData()

            if currentTime - userDefaults.integer(forKey: "groupsLastLoad") > 0 || realmGroups.isEmpty {
                firstly {
                    self.getGroupsPromise.fetchUserGroups()
                }.compactMap(on: DispatchQueue.global()) { [weak self] data in
                    self?.getGroupsPromise.parseGroups(data: data)
                }.compactMap(on: DispatchQueue.global()) { groupResponse in
                    groupResponse.value?.items
                }.done(on: DispatchQueue.global()) { groups in
                    userDefaults.set(currentTime, forKey: "groupsLastLoad")
                    RealmGroup.saveData(data: groups)
                }.catch { error in
                    print(error)
                }
            } else {
                var groups: [Community] = []

                for realmGroup in realmGroups {
                    groups.append(self.realmGroupsToGroups(realmGroup))
                }

                completion(groups, nil)
            }
        } catch {
            print(error)
        }
    }

    func getSearchedGroups(with searchText: String, completion: @escaping ([Community], ([Int], [Int], [Int])?) -> Void) {
        if searchText.isEmpty, let realmGroups = try? RealmGroup.restoreData() {
            var groups: [Community] = []

            for realmGroup in realmGroups {
                groups.append(self.realmGroupsToGroups(realmGroup))
            }

            completion(groups, nil)
        } else {
            firstly {
                getGroupsPromise.fetchSearchedGroups(by: searchText)
            }.compactMap(on: DispatchQueue.global()) { [weak self] data in
                self?.getGroupsPromise.parseGroups(data: data)
            }.compactMap(on: DispatchQueue.global()) { groupsResponse in
                groupsResponse.value?.items
            }.compactMap(on: DispatchQueue.global()) { groups in
                groups.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }.done(on: DispatchQueue.main) { groups in
                completion(groups, nil)
            }.catch { error in
                print(error)
            }
        }
    }

    // MARK: - Private functionsg

    private func realmGroupsToGroups(_ realmGroup: RealmGroup) -> Community {
        return Community(id: realmGroup.id,
                     name: realmGroup.name,
                     isMember: realmGroup.isMember,
                     avatar: realmGroup.avatar,
                     isClosed: realmGroup.isClosed)
    }
}
