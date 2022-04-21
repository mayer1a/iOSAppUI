//
//  GroupsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit


final class GroupsTableViewController: UITableViewController {

    private let customSearchView = CustomSearchBarView().loadView()

    var myGroups: [Group] = []
    var displayedGroups: [Group] = []


    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customSearchViewConfiguration()
        setupData()

    }


    // MARK: - viewWillTransition

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { _ in
            self.sizeHeaderToFit()
        }
    }


    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }


    // MARK: - numberOfRowsInSection

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups.count
    }


    // MARK: - cellForRowAt

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell",
                                                 for: indexPath) as? GroupTableViewCell

        guard let groupAvatarName = displayedGroups[indexPath.row].avatar,
              let path = Bundle.main.path(forResource: groupAvatarName, ofType: "jpg"),
              let groupAvatar = cell?.groupImage?.resizedImage(at: path, for: imageSize())
        else {
            return UITableViewCell()
        }

        cell?.groupImage?.image = groupAvatar
        cell?.groupName?.text = displayedGroups[indexPath.row].name

        return cell ?? UITableViewCell()
    }


    // MARK: - trailingSwipeActionsConfigurationForRowAt

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive,
                                        title: "Отписаться",
                                        handler: { [weak self] _, _, block in

            guard let groupToUnsubscribe = self?.myGroups.remove(at: indexPath.row) else { return }

            Group.nonSubscribedGroups.append(groupToUnsubscribe)

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


    // MARK: - setupData

    private func setupData() {
        myGroups = Group.subscribedGroups
        displayedGroups = myGroups
    }


    // MARK: - imageSize

    private func imageSize() -> CGSize {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        return view.bounds.size.applying(scale)
    }


    // MARK: - configurateCustomSearchView

    private func customSearchViewConfiguration() {

        tableView.tableHeaderView = customSearchView

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
        guard let headerView = tableView.tableHeaderView else { return }

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let width = tableView.safeAreaLayoutGuide.layoutFrame.size.width
        var frame = headerView.frame

        frame.size.height = height
        frame.size.width = width
        frame.origin = tableView.safeAreaLayoutGuide.layoutFrame.origin
        headerView.frame = frame

        tableView.tableHeaderView = headerView
    }


    // MARK: - updateDisplayedGroups

    private func updateDisplayedGroups(searchText: String) {

        guard !searchText.isEmpty else {
            displayedGroups = myGroups
            tableView.reloadData()

            return
        }

        displayedGroups = myGroups.filter { $0.name.lowercased().contains(searchText.lowercased()) }

        tableView.reloadData()
    }

}


// MARK: - SearchGroupTableViewControllerDelegate

extension GroupsTableViewController: SearchGroupTableViewControllerDelegate {


    // MARK: - subscribeGroup

    func subscribeGroup(group: Group) {

        guard
            let removeGroupIndex = Group.nonSubscribedGroups.enumerated().first(where: {
                $0.element.id == group.id
            })?.offset
        else {
            return
        }

        myGroups.append(group)

        Group.nonSubscribedGroups.remove(at: removeGroupIndex)
        updateDisplayedGroups(searchText: customSearchView?.searchTextField?.text ?? "")
    }

}
