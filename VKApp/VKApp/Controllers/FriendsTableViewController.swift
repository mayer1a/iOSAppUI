//
//  FriendsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit

// MARK: - UITableViewController
class FriendsTableViewController: UITableViewController {

    let users: [User] = User.friends

    // MARK: - DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell",
                                                 for: indexPath) as? FriendsTableViewCell

        guard let avatarName = users[indexPath.row].avatar,
              let path = Bundle.main.path(forResource: avatarName, ofType: "jpg"),
              let userAvatar = cell?.friendImage?.resizedImage(at: path, for: imageSize())
        else {
            return UITableViewCell()
        }

        cell?.friendImage?.image = userAvatar
        cell?.friendName?.text = "\(users[indexPath.row].name) \(users[indexPath.row].surname)"

        return cell ?? UITableViewCell()
    }

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
}
