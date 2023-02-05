//
//  GroupsViewModel.swift
//  VKApp
//
//  Created by Artem Mayer on 31.01.2023.
//

import Foundation
import RealmSwift
import PromiseKit

final class GroupsViewModel: ObservableObject {

    // MARK: - Private properties

    private let getGroupsPromise: GetUserGroups

    private var notificationToken: NotificationToken?

    private lazy var groups: Results<RealmGroup>? = try? RealmGroup.getData()

    // MARK: - Properties

    let objectWillChange = ObjectWillChangePublisher()

    var detachedGroups: [Group] {
        let detached = (groups?.map { $0.detached() }) ?? []

        return RealmGroup.realmToGroup(from: detached)
    }

    // MARK: - Constructions

    init(getGroupsPromise: GetUserGroups) {
        self.getGroupsPromise = getGroupsPromise

        changesSubscribe()
    }

    // MARK: - Functions

    func fetchGroups() {
        let userDefaults = UserDefaults.standard
        let currentTime = Int(Date().timeIntervalSince1970)

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
    }

    // MARK: - Private functions

    private func changesSubscribe() {
        notificationToken = groups?.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}
