//
//  GroupsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit
import RealmSwift


final class GroupsTableViewController: UITableViewController {

    private let customSearchView = CustomSearchBarView().loadView()
    private var realmNotification: NotificationToken?
    var myGroups: [Group]?
    var displayedGroups: [Group]?


    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customSearchViewConfiguration()
        makeObserver()
        dataValidityCheck()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell",
                                                 for: indexPath) as? GroupTableViewCell

        guard
            let groupAvatarName = displayedGroups?[indexPath.row].avatar,
            let path = URL(string: groupAvatarName)
        else {
            return UITableViewCell()
        }

        DispatchQueue.global().async {
            let image = cell?.groupImage?.resizedImage(at: path)

            DispatchQueue.main.async {
                cell?.groupImage?.image = image
            }
        }

        cell?.groupName?.text = displayedGroups?[indexPath.row].name

        return cell ?? UITableViewCell()
    }


    // MARK: - trailingSwipeActionsConfigurationForRowAt

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive,
                                        title: "Отписаться",
                                        handler: { _, _, block in

            //            guard let groupToUnsubscribe = self?.myGroups.remove(at: indexPath.row) else { return }

            //            GroupTestData.nonSubscribedGroups.append(groupToUnsubscribe)
            // TODO: метод отписки от группы

            block(true)

        })

        return UISwipeActionsConfiguration(actions: [action])
    }


    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchGroupVC = segue.destination as? SearchGroupTableViewController {
            searchGroupVC.delegate = self
        }
    }


    // MARK: - customSearchBarDidTapped

    @objc func customSearchBarDidTapped() {
        guard let customSearchView = customSearchView else { return }

        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: [.curveEaseInOut]) { [weak self] in

            customSearchView.closeButtonTrailingConstraint?.isActive = true
            customSearchView.searchTextFieldLeadingAnchor?.isActive = true
            customSearchView.searchIconCenterXConstraint?.isActive = false
            customSearchView.searchTextFieldTrailingConstraint?.isActive = false

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

            customSearchView.searchIconCenterXConstraint?.isActive = true
            customSearchView.searchTextFieldTrailingConstraint?.isActive = true
            customSearchView.closeButtonTrailingConstraint?.isActive = false
            customSearchView.searchTextFieldLeadingAnchor?.isActive = false

            self?.tableView.layoutIfNeeded()
        }

        customSearchView.searchTextField?.text = ""
        updateDisplayedGroups(searchText: "")

        customSearchView.searchTextField?.resignFirstResponder()

    }


    // MARK: - customSearchTextDidChange

    @objc func customSearchTextDidChange(_ sender: Any) {
        guard let sender = sender as? UITextField, let inputText = sender.text else { return }

        updateDisplayedGroups(searchText: inputText)
    }


    // MARK: - @objc tapOutKeyboard

    @objc private func tapOutKeyboard() {
        customSearchView?.searchTextField?.resignFirstResponder()
    }


    // MARK: - searchBarDidTapped

    @objc private func searchBarDidTapped() {
        customSearchView?.searchTextField?.resignFirstResponder()
    }


    // MARK: - makeObserver

    private func makeObserver() {
        
        self.realmNotification = RealmObserver.shared.makeObserver(RealmGroup.self) { groups, changes in
            DispatchQueue.main.async { [weak self] in
                self?.setupData(from: groups, with: changes)
            }
        }
    }


    // MARK: - dataValidityCheck

    private func dataValidityCheck() {

        do {
            let groups = try RealmGroup.restoreData()
            let userDefaults = UserDefaults.standard
            let currentTime = Int(Date().timeIntervalSince1970)

            if currentTime - userDefaults.integer(forKey: "groupsLastLoad") > 10_000 || groups.isEmpty {
                SessionManager.shared.loadMyGroups()

                userDefaults.set(currentTime, forKey: "groupsLastLoad")
            } else {
                self.setupData(from: groups)
            }
        } catch {
            print(error)
        }
    }


    // MARK: - setupData

    private func setupData(from groups: [RealmGroup], with changes: ([Int], [Int], [Int])? = nil) {
        let myGroups = RealmGroup.realmToGroup(from: groups)
        self.myGroups = myGroups
        self.displayedGroups = myGroups

        if let changes = changes {
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
        } else {
            self.tableView.reloadData()
        }
    }


    // MARK: - configurateCustomSearchView

    private func customSearchViewConfiguration() {

        self.tableView.tableHeaderView = customSearchView

        customSearchView?.insetsLayoutMarginsFromSafeArea = true

        customSearchView?.searchTextField?.addTarget(self,
                                                     action: #selector(customSearchBarDidTapped),
                                                     for: .editingDidBegin)

        customSearchView?.searchTextField?.addTarget(self,
                                                     action: #selector(customSearchTextDidChange(_:)),
                                                     for: .editingChanged)

        customSearchView?.searchTextField?.addTarget(self,
                                                     action: #selector(searchBarDidTapped),
                                                     for: .editingDidEndOnExit)

        customSearchView?.searchCloseButton?.addTarget(self,
                                                       action: #selector(cancelButtonDidTapped),
                                                       for: .touchUpInside)

        sizeHeaderToFit()
    }


    // MARK: - sizeHeaderToFit

    private func sizeHeaderToFit() {
        guard let headerView = self.tableView.tableHeaderView else { return }

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let width = self.tableView.safeAreaLayoutGuide.layoutFrame.size.width
        var frame = headerView.frame

        frame.size.height = height
        frame.size.width = width
        frame.origin = self.tableView.safeAreaLayoutGuide.layoutFrame.origin
        headerView.frame = frame

        self.tableView.tableHeaderView = headerView
    }


    // MARK: - updateDisplayedGroups

    private func updateDisplayedGroups(searchText: String) {

        if searchText.isEmpty, let myGroups = try? RealmGroup.restoreData() {

            setupData(from: myGroups)
        } else {
            SessionManager.shared.loadSearchedGroups(searchText: searchText) { [weak self] groups in
                guard let self = self else { return }

                self.displayedGroups = groups.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: - SearchGroupTableViewControllerDelegate

extension GroupsTableViewController: SearchGroupTableViewControllerDelegate {


    // MARK: - subscribeGroup

    func subscribeGroup(group: GroupTestData) {

        //        guard
        //            let removeGroupIndex = GroupTestData.nonSubscribedGroups.enumerated().first(where: {
        //                $0.element.id == group.id
        //            })?.offset
        //        else {
        //            return
        //        }

        //        myGroups.append(group)

        //        GroupTestData.nonSubscribedGroups.remove(at: removeGroupIndex)
        updateDisplayedGroups(searchText: customSearchView?.searchTextField?.text ?? "")
    }

}
