//
//  SearchGroupTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit

// MARK: - UITableViewController
final class SearchGroupTableViewController: UITableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    // MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell",
                                                 for: indexPath) as? SearchGroupTableViewCell
        
        return cell ?? UITableViewCell()
    }

    // MARK: - trailingSwipeActionsConfigurationForRowAt
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let action = UIContextualAction(style: .normal, title: "Подписаться") { _, _, block in
            tableView.deleteRows(at: [indexPath], with: .left)

            block(true)
        }

        action.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [action])
    }
}
