//
//  SearchGroupTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit

class SearchGroupTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Group.nonSubscribedGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell",
                                                 for: indexPath) as? SearchGroupTableViewCell
        
        let groups = Group.nonSubscribedGroups
        
        guard let groupAvatarName = groups[indexPath.row].avatar,
              let path = Bundle.main.path(forResource: groupAvatarName, ofType: "jpg"),
              let groupAvatar = cell?.groupImage?.resizedImage(at: path, for: imageSize())
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
                                        handler: { [weak self] _, _, block in
            
            let groupToSubscribe = Group.nonSubscribedGroups.remove(at: indexPath.row)
            Group.subscribedGroups.append(groupToSubscribe)
            
            self?.tableView.deleteRows(at: [indexPath], with: .left)
            
            block(true)
            
        })
        
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
