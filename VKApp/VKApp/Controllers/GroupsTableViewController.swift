//
//  GroupsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit
import RealmSwift
import FirebaseFirestore
import PromiseKit

// MARK: UITableViewController
final class GroupsTableViewController: UITableViewController {
    private let customSearchView = CustomSearchBarView().loadView()
    private let getGroupsPromise = GetUserGroups()
    private var imageCachingService: ImageCachingService?
    private var realmNotification: NotificationToken?
    var myGroups: [Group]?
    var displayedGroups: [Group]?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCachingService = ImageCachingService(from: self.tableView)
        customSearchViewConfiguration()
        makeObserver()
        dataValidityCheck()
    }

    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sizeHeaderToFit()
    }

    // MARK: - viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { _ in
            self.sizeHeaderToFit()
        }
    }

    // MARK: - numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups?.count ?? 0
    }

    // MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell

        guard let imagePath = displayedGroups?[indexPath.row].avatar
        else { return UITableViewCell() }
        
        imageCachingService?.getImage(at: indexPath, by: imagePath) { image in
            cell?.groupImage?.image = image
        }

        cell?.groupName?.text = displayedGroups?[indexPath.row].name

        return cell ?? UITableViewCell()
    }

    // MARK: - trailingSwipeActionsConfigurationForRowAt
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let action = UIContextualAction(style: .destructive, title: "Отписаться") { _, _, block in
            block(true)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    // MARK: - heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(93)
    }

    // MARK: - traitCollectionDidChange
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard customSearchView?.searchTextField?.isFirstResponder == true else { return }

        tableView.layoutIfNeeded()

        customSearchView?.searchIconCenterXConstraint?.isActive = false
        customSearchView?.searchTextFieldTrailingConstraint?.isActive = false
        customSearchView?.closeButtonTrailingConstraint?.isActive = true
        customSearchView?.searchTextFieldLeadingAnchor?.isActive = true
    }

    // MARK: - customSearchBarDidTapped
    @objc func customSearchBarDidTapped() {
        guard let customSearchView = customSearchView else { return }

        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: [.curveEaseInOut]) { [weak self] in

            customSearchView.searchIconCenterXConstraint?.isActive = false
            customSearchView.searchTextFieldTrailingConstraint?.isActive = false
            customSearchView.closeButtonTrailingConstraint?.isActive = true
            customSearchView.searchTextFieldLeadingAnchor?.isActive = true
            customSearchView.searchTextField?.placeholder = "Поиск"

            self?.tableView.layoutIfNeeded()
        }
    }

    // MARK: - cancelButtonDidTapped
    @objc private func cancelButtonDidTapped() {
        guard let customSearchView = customSearchView else { return }

        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: [.curveEaseInOut]) { [weak self] in

            customSearchView.closeButtonTrailingConstraint?.isActive = false
            customSearchView.searchTextFieldLeadingAnchor?.isActive = false
            customSearchView.searchIconCenterXConstraint?.isActive = true
            customSearchView.searchTextFieldTrailingConstraint?.isActive = true

            self?.tableView.layoutIfNeeded()
        }

        customSearchView.searchTextField?.text = ""
        customSearchView.searchTextField?.placeholder = ""
        updateDisplayedGroups(searchText: "")

        customSearchView.searchTextField?.resignFirstResponder()
    }

    // MARK: - customSearchTextDidChange
    @objc func customSearchTextDidChange(_ sender: UITextField) {
        guard let inputText = sender.text else { return }

        updateDisplayedGroups(searchText: inputText)
    }

    // MARK: - makeObserver
    private func makeObserver() {
        self.realmNotification = RealmObserver.shared.makeObserver { (groups: [RealmGroup], changes) in
            DispatchQueue.main.async { [weak self] in
                self?.setupData(from: groups, with: changes)
//                self?.writeFirebase(data: self?.myGroups)
            }
        }
    }

    // MARK: - dataValidityCheck
    private func dataValidityCheck() {
        var groups = [RealmGroup]()
        let userDefaults = UserDefaults.standard
        let currentTime = Int(Date().timeIntervalSince1970)

        do {
            groups = try RealmGroup.restoreData()
        } catch {
            print(error)
        }

        guard
            currentTime - userDefaults.integer(forKey: "groupsLastLoad") > 0 || groups.isEmpty
        else {
            self.setupData(from: groups)
            return
        }

        firstly {
            self.getGroupsPromise.fetchUserGroups()
        }.compactMap(on: DispatchQueue.global()) { [weak self] data in
            self!.getGroupsPromise.parseGroups(data: data)
        }.compactMap(on: DispatchQueue.global()) { groupResponse in
            groupResponse.value?.items
        }.done(on: DispatchQueue.global()) { groups in
            userDefaults.set(currentTime, forKey: "groupsLastLoad")
            RealmGroup.saveData(data: groups)
        }.catch { error in
            print(error)
        }
    }

    // MARK: - setupData
    private func setupData(from groups: [RealmGroup], with changes: ([Int], [Int], [Int])? = nil) {
        let myGroups = RealmGroup.realmToGroup(from: groups)
        self.myGroups = myGroups
        self.displayedGroups = myGroups

        guard
            let changes = changes
        else {
            self.tableView.reloadData()
            return
        }

        DispatchQueue.global().async {
            let deletionIndexes = changes.0.reduce(into: [IndexPath]()) {
                $0.append(IndexPath(row: $1, section: 0))
            }

            let insertionIndexes = changes.1.reduce(into: [IndexPath]()) {
                $0.append(IndexPath(row: $1, section: 0))
            }

            let reloadIndexes = changes.2.reduce(into: [IndexPath]()) {
                $0.append(IndexPath(row: $1, section: 0))
            }

            DispatchQueue.main.async {
                self.tableView.beginUpdates()

                self.tableView.deleteRows(at: deletionIndexes, with: .none)
                self.tableView.insertRows(at: insertionIndexes, with: .none)
                self.tableView.reloadRows(at: reloadIndexes, with: .none)

                self.tableView.endUpdates()
            }
        }
    }

    // MARK: - writeFirebaseData
    private func writeFirebase(data: [Group]?) {
        guard let usersGroups = data, let userId = Session.shared.userID else { return }

        let firebaseFirestore = Firestore.firestore()
        var groups = [String: String]()

        usersGroups.forEach { groups[String($0.id)] = $0.name }

        let data: [String: Any] = [FirestoreNames.documentField.rawValue: groups]

        firebaseFirestore
            .collection(FirestoreNames.collectionName.rawValue)
            .document(String(userId))
            .setData(data) { error in
                guard let error = error else { return }
                print("Error adding document: \(error)")
            }
    }

    // MARK: - configurateCustomSearchView
    private func customSearchViewConfiguration() {
        self.tableView.tableHeaderView = customSearchView

        customSearchView?.searchTextField?.addTarget(self,
                                                     action: #selector(customSearchBarDidTapped),
                                                     for: .editingDidBegin)

        customSearchView?.searchTextField?.addTarget(self,
                                                     action: #selector(customSearchTextDidChange),
                                                     for: .editingChanged)

        customSearchView?.searchTextField?.addTarget(self,
                                                     action: #selector(cancelButtonDidTapped),
                                                     for: .editingDidEndOnExit)

        customSearchView?.searchCloseButton?.addTarget(self,
                                                       action: #selector(cancelButtonDidTapped),
                                                       for: .touchUpInside)
        // add target on rightView

    }
    @objc private func test(_ sender: Any) {
        print("clear")
    }
    // MARK: - sizeHeaderToFit
    private func sizeHeaderToFit() {
        guard let headerView = self.tableView.tableHeaderView else { return }

        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        var frame = headerView.frame
        frame.size.height = height

        headerView.frame = frame

        self.tableView.tableHeaderView = headerView
    }

    // MARK: - updateDisplayedGroups
    private func updateDisplayedGroups(searchText: String) {
        if searchText.isEmpty, let myGroups = try? RealmGroup.restoreData() {
            setupData(from: myGroups)
        } else {
            firstly {
                getGroupsPromise.fetchSearchedGroups(by: searchText)
            }.compactMap(on: DispatchQueue.global()) { [weak self] data in
                self?.getGroupsPromise.parseGroups(data: data)
            }.compactMap(on: DispatchQueue.global()) { groupsResponse in
                groupsResponse.value?.items
            }.compactMap(on: DispatchQueue.global()) { groups in
                groups.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }.done(on: DispatchQueue.main) { [weak self] groups in
                self?.displayedGroups = groups
                self?.tableView.reloadData()
            }.catch { error in
                print(error)
            }
        }
    }
}
