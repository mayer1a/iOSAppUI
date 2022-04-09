//
//  GroupsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit

class GroupsTableViewController: UITableViewController {

    @IBOutlet weak var groupSearchBar: UISearchBar?

    var myGroups: [Group] = []
    var displayedGroups: [Group] = []


    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupSearchBar?.delegate = self

        myGroups = Group.subscribedGroups
        displayedGroups = myGroups

        // Hide the keyboard when tapping out
        let hideKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOutKeyboard))
        hideKeyboardTapGestureRecognizer.numberOfTapsRequired = 1
        hideKeyboardTapGestureRecognizer.isEnabled = true
        hideKeyboardTapGestureRecognizer.cancelsTouchesInView = false

        self.view.addGestureRecognizer(hideKeyboardTapGestureRecognizer)

    }


    // MARK: - @objc tapOutKeyboard

    @objc func tapOutKeyboard() {
        groupSearchBar?.resignFirstResponder()
        groupSearchBar?.endEditing(true)
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


    // MARK: - imageSize

    func imageSize() -> CGSize {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        return view.bounds.size.applying(scale)
    }


    // MARK: - trailingSwipeActionsConfigurationForRowAt

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive,
                                        title: "Отписаться",
                                        handler: { [weak self] _, _, block in

            guard let groupToUnsubscribe = self?.myGroups.remove(at: indexPath.row) else { return }

            Group.nonSubscribedGroups.append(groupToUnsubscribe)

            self?.updateDisplayedGroups(searchText: self?.groupSearchBar?.text ?? "")

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

}


// MARK: - SearchGroupTableViewControllerDelegate

extension GroupsTableViewController: SearchGroupTableViewControllerDelegate {

    func subscribeGroup(group: Group) {

        guard let removeGroupIndex = Group.nonSubscribedGroups.enumerated().first(where: {
            $0.element.id == group.id
        })?.offset else {
            return
        }

        myGroups.append(group)

        Group.nonSubscribedGroups.remove(at: removeGroupIndex)
        updateDisplayedGroups(searchText: groupSearchBar?.text ?? "")
    }

}


// MARK: - UISearchBarDelegate

extension GroupsTableViewController: UISearchBarDelegate {

    // MARK: - searchBarTextDidChange

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateDisplayedGroups(searchText: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }


    // MARK: - updateDisplayedGroups

    func updateDisplayedGroups(searchText: String) {

        guard !searchText.isEmpty else {
            displayedGroups = myGroups
            tableView.reloadData()

            return
        }

        displayedGroups = myGroups.filter { $0.name.lowercased().contains(searchText.lowercased()) }

        tableView.reloadData()
    }

}
