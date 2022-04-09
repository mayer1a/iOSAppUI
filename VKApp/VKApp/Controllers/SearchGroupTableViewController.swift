//
//  SearchGroupTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit

protocol SearchGroupTableViewControllerDelegate {
    func subscribeGroup(group: Group)
}

class SearchGroupTableViewController: UITableViewController {

    var nonSubscribedGroups: [Group] = []
//    var subscribedGroups: [Group] = []
    var delegate: SearchGroupTableViewControllerDelegate?

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nonSubscribedGroups = Group.nonSubscribedGroups
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonSubscribedGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell",
                                                 for: indexPath) as? SearchGroupTableViewCell
        
        guard let groupAvatarName = nonSubscribedGroups[indexPath.row].avatar,
              let path = Bundle.main.path(forResource: groupAvatarName, ofType: "jpg"),
              let groupAvatar = cell?.groupImage?.resizedImage(at: path, for: imageSize())
        else {
            return UITableViewCell()
        }
        
        cell?.groupImage?.image = groupAvatar
        cell?.groupName?.text = nonSubscribedGroups[indexPath.row].name
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal,
                                        title: "Подписаться",
                                        handler: { [weak self] _, _, block in
            
            guard let groupToSubscribe = self?.nonSubscribedGroups.remove(at: indexPath.row) else { return }

//            self?.subscribedGroups.append(groupToSubscribe)

            tableView.deleteRows(at: [indexPath], with: .left)

            self?.delegate?.subscribeGroup(group: groupToSubscribe)

            block(true)
            
        })

        action.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

extension SearchGroupTableViewController {
    func imageSize() -> CGSize {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        return view.bounds.size.applying(scale)
    }
}
