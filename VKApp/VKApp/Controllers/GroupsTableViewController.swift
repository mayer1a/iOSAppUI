//
//  GroupsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit

class GroupsTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Group.subscribedGroups.append(contentsOf: [Group.nonSubscribedGroups.removeFirst(),
                                                   Group.nonSubscribedGroups.removeFirst()])
    }
}

extension GroupsTableViewController {
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Group.subscribedGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell",
                                                 for: indexPath) as? GroupTableViewCell

        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let size = view.bounds.size.applying(scale)

        guard let groupAvatarName = Group.subscribedGroups[indexPath.row].avatar,
              let path = Bundle.main.path(forResource: groupAvatarName, ofType: "jpg"),
              let groupAvatar = cell?.groupImage?.resizedImage(at: path, for: size)
        else {
            return UITableViewCell()
        }

        cell?.groupImage?.image = groupAvatar
        cell?.groupName?.text = Group.subscribedGroups[indexPath.row].name

        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal,
                                       title: "Отписаться",
                                       handler: { [weak self] action, view, block in

            guard let self = self else { return }

            self.tableView.beginUpdates()

            let groupToUnSubscribe = Group.subscribedGroups.remove(at: indexPath.row)
            Group.nonSubscribedGroups.append(groupToUnSubscribe)

            self.tableView.deleteRows(at: [indexPath], with: .left)

            self.tableView.endUpdates()

            block(true)

        })
        return UISwipeActionsConfiguration(actions: [action])
    }

}
