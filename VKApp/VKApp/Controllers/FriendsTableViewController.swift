//
//  FriendsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit

// MARK: - GrouppedFriends

struct GrouppedFriends {
    let character: Character
    var users: [User]
}

// MARK: - UITableViewController
class FriendsTableViewController: UITableViewController {

    private let users: [User] = User.friends

    // Group friends by first letter of last name
    var grouppedFriends: [GrouppedFriends] {
        var result = [GrouppedFriends]()

        for user in users {
            guard let character = user.surname.first else { continue }

            if let currentCharacter = result.firstIndex(where: { $0.character == character }) {
                result[currentCharacter].users.append(user)
            } else {
                result.append(GrouppedFriends(character: character, users: [user]))
            }
        }

        return result.sorted(by: { $0.character < $1.character })
    }

    // MARK: - DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grouppedFriends[section].users.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return grouppedFriends.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(grouppedFriends[section].character)
    }

    // Adding custom header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        // Adding a label for the first letter of the last name
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 0, y: 0, width: 320, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        headerView.addSubview(myLabel)

        // Setting label constraints
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: CGFloat(20)).isActive = true
        myLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: CGFloat(5)).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: CGFloat(-5)).isActive = true

        return headerView
    }

    // Remove top header padding
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.sectionHeaderTopPadding = CGFloat(0)

        // Removing the bottom separator from the last cell of a section
        if indexPath.row == grouppedFriends[indexPath.section].users.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: tableView.bounds.minX)
        }
    }

    // Configure cell by section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell",
                                                 for: indexPath) as? FriendsTableViewCell

        let grouppedFriend = grouppedFriends[indexPath.section]
        let friend = grouppedFriend.users[indexPath.row]

        guard let avatarName = friend.avatar,
              let path = Bundle.main.path(forResource: avatarName, ofType: "jpg"),
              let userAvatar = cell?.friendImage?.resizedImage(at: path, for: imageSize())
        else {
            return UITableViewCell()
        }

        cell?.friendImage?.image = userAvatar
        cell?.friendName?.text = "\(friend.name) \(friend.surname)"

        return cell ?? UITableViewCell()
    }

    // Scale based on screen size
    func imageSize() -> CGSize {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        return view.bounds.size.applying(scale)
    }

    // Prepare data to transfer at next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell),
              let friendPhotoVC = segue.destination as? FriendPhotosCollectionViewController else {
            return
        }

        if segue.identifier == "ShowFriendPhotos" {
            friendPhotoVC.userPhotos = users[indexPath.row].photos ?? [String]()
        }
    }

    // Automatic cell height calculation
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
