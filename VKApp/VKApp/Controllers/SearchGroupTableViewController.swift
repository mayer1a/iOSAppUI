//
//  SearchGroupTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit

class SearchGroupTableViewController: UITableViewController {

    //var userDidUnsubscribe: ((Group) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Group.nonSubscribedGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell",
                                                 for: indexPath) as? SearchGroupTableViewCell

        let groups = Group.nonSubscribedGroups

        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let size = view.bounds.size.applying(scale)

        guard let groupAvatarName = groups[indexPath.row].avatar,
              let path = Bundle.main.path(forResource: groupAvatarName, ofType: "jpg"),
              let groupAvatar = cell?.groupImage?.resizedImage(at: path, for: size)
        else {
            return UITableViewCell()
        }

        cell?.groupImage?.image = groupAvatar
        cell?.groupName?.text = groups[indexPath.row].name

        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal,
                                        title: "Подписаться",
                                        handler: { [weak self] action, view, block in

            guard let self = self else { return }

            self.tableView.beginUpdates()

            let groupToSubscribe = Group.nonSubscribedGroups.remove(at: indexPath.row)
            Group.subscribedGroups.append(groupToSubscribe)

            self.tableView.deleteRows(at: [indexPath], with: .left)

            self.tableView.endUpdates()

            block(true)

        })

        return UISwipeActionsConfiguration(actions: [action])
    }

    

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

}
