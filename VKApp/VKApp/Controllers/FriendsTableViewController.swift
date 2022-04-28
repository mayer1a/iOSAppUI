//
//  FriendsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit


// MARK: - UITableViewController

final class FriendsTableViewController: UITableViewController {

    private let users: [User] = User.friends

    private lazy var cloudView: CloudView? = {
        return CloudView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 100)))
    }()

    // Group friends by first letter of last name
    var grouppedFriends: [GrouppedFriends] = []


    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderTopPadding = CGFloat(0)
        cloudView?.translatesAutoresizingMaskIntoConstraints = false
        
        grouppedFriends = groupFriends()
    }


    // MARK: - didSelectRowAt

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // At the end of the timer, the animation ends and perform segue to the next controller
        Timer.scheduledTimer(timeInterval: 4,
                             target: self,
                             selector: #selector(stopAnimation),
                             userInfo: nil,
                             repeats: false)

        setupAnimation()
        cloudView?.startAnimation()

        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            self?.cloudView?.alpha = 0.75
        }

    }


    // MARK: - willSelectRowAt

    // Exclusion of re-transition when loading the original segue while the animation is being displayed
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.tableView.indexPathForSelectedRow == nil ? indexPath : nil
    }


    // MARK: - configureDownloadIndicatorView

    private func setupAnimation() {
        guard
            let cloudView = cloudView,
            let tabBarView = tabBarController?.view
        else {
            return
        }

        // Add an indicatorView to the tabbar so that the indicatorView is above the tableView
        tabBarView.addSubview(cloudView)

        NSLayoutConstraint.activate([
            tabBarView.centerXAnchor.constraint(equalTo: cloudView.centerXAnchor),
            tabBarView.centerYAnchor.constraint(equalTo: cloudView.centerYAnchor)
        ])
    }


    // MARK: - @objc stopAnimation

    @objc func stopAnimation() {

        guard let tableView = self.tableView else { return }

        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            self?.cloudView?.alpha = 0.1
        }
        
        self.cloudView?.removeAnimation()
        self.cloudView?.removeFromSuperview()

        self.performSegue(withIdentifier: "ShowFriendPhotos",
                          sender: tableView.indexPathForSelectedRow)
    }


    // MARK: - groupFriends

    func groupFriends() -> [GrouppedFriends] {
        var result = [GrouppedFriends]()

        for user in users {
            guard let character: Character = user.surname.first else { continue }

            if let currentCharacter = result.firstIndex(where: { $0.character == character }) {
                result[currentCharacter].users.append(user)
            } else {
                result.append(GrouppedFriends(character: character, users: [user]))
            }
        }

        // Sorted by ascending localized case insensitive letter
        result = result.sorted {
            (String($0.character)).localizedCaseInsensitiveCompare(String($1.character)) == .orderedAscending
        }

        GrouppedFriends.list = result

        return result
    }


    // MARK: - numberOfRowsInSection

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grouppedFriends[section].users.count
    }


    // MARK: - numberOfSections

    override func numberOfSections(in tableView: UITableView) -> Int {
        return grouppedFriends.count
    }


    // MARK: - titleForHeaderInSection

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(grouppedFriends[section].character)
    }


    // MARK: - viewForHeaderInSection

    // Adding custom header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        // Adding and configurating reusable header
        let headerView = UITableViewHeaderFooterView()
        var contentConfiguration = headerView.defaultContentConfiguration()

        contentConfiguration.text = self.tableView(tableView, titleForHeaderInSection: section)
        contentConfiguration.textProperties.alignment = .natural

        headerView.contentConfiguration = contentConfiguration
        headerView.contentView.backgroundColor = .systemGray6
        headerView.alpha = 0.5

        return headerView
    }


    // MARK: - tableViewWillDisplayForRowAt

    // Remove top header padding
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // Removing the bottom separator from the last cell of a section
        if indexPath.row == grouppedFriends[indexPath.section].users.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: tableView.bounds.minX)
        }
    }


    // MARK: - cellForRowAt

    // Configure cell by section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell",
                                                 for: indexPath) as? FriendsTableViewCell

        let friend = grouppedFriends[indexPath.section].users[indexPath.row]

        guard let avatarName = friend.avatar,
              let path = Bundle.main.path(forResource: avatarName, ofType: "jpg"),
              let userAvatar = cell?.friendImage?.resizedImage(at: path, for: imageSize())
        else {
            return UITableViewCell()
        }

        cell?.friendImage?.image = userAvatar
        cell?.friendName?.text = "\(friend.name) \(friend.surname)"
        //cell?.friendPhotoView?.layer.add(animateFriendPhoto(), forKey: nil)

        return cell ?? UITableViewCell()
    }


    // MARK: - imageSize

    // Scale based on screen size
    func imageSize() -> CGSize {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        return view.bounds.size.applying(scale)
    }

    // MARK: - prepareForSender

    // Prepare data to transfer at next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath,
              let friendPhotoVC = segue.destination as? FriendPhotosCollectionViewController else {
            return
        }

        if segue.identifier == "ShowFriendPhotos" {
            friendPhotoVC.userPhotos =  grouppedFriends[indexPath.section].users[indexPath.row].photos ?? [Photo]()
            friendPhotoVC.tableViewIndexPath = indexPath
            friendPhotoVC.delegate = self
        }
    }


    // MARK: - heightForRowAt

    // Automatic cell height calculation
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - FriendPhotosCollectionViewControllerDelegate

extension FriendsTableViewController: FriendPhotosCollectionViewControllerDelegate {

    func photoDidLiked(userIndexPath: IndexPath, photoIndexPath: IndexPath, isLiked: Bool) {
        grouppedFriends[userIndexPath.section].users[userIndexPath.row].photos?[photoIndexPath.item].isLiked = isLiked
    }
    
}
