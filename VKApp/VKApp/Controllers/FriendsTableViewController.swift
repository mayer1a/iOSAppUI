//
//  FriendsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit
import RealmSwift

// MARK: - UITableViewController
final class FriendsTableViewController: UITableViewController {
    private var friends: [User]?
    private var alphabetControl: FriendsAlphabetView?
    private var realmNotification: NotificationToken?
    var grouppedFriends = [GrouppedFriends]()

    private lazy var cloudView: CloudView? = {
        return CloudView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 100)))
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderTopPadding = CGFloat(0)
        cloudView?.translatesAutoresizingMaskIntoConstraints = false

        makeObserver()
        dataValidityCheck()
    }

    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAlphabetView()
    }

    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        alphabetControl?.removeFromSuperview()
    }

    // MARK: - viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { _ in
            if self.view.window != nil {
                self.setupAlphabetView()
            }
        }
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

    // MARK: - makeObserver
    private func makeObserver() {
        self.realmNotification = RealmObserver.shared.makeObserver { (friends: [RealmUser], changes) in
            DispatchQueue.main.async { [weak self] in
                self?.setupData(from: friends, with: changes)
            }
        }
    }

    // MARK: - setupAnimation
    private func setupAnimation() {
        guard let cloudView = cloudView, let tabBarView = tabBarController?.view else { return }

        // Add an indicatorView to the tabbar so that the indicatorView is above the tableView
        tabBarView.addSubview(cloudView)

        NSLayoutConstraint.activate([
            tabBarView.centerXAnchor.constraint(equalTo: cloudView.centerXAnchor),
            tabBarView.centerYAnchor.constraint(equalTo: cloudView.centerYAnchor)
        ])
    }

    // MARK: - dataValidityCheck
    private func dataValidityCheck() {
        do {
            let friends = try RealmUser.restoreData()
            let userDefaults = UserDefaults.standard
            let currentTime = Int(Date().timeIntervalSince1970)

            if currentTime - userDefaults.integer(forKey: "friendsLastLoad") > 10_000 || friends.isEmpty {
                SessionManager.shared.fetchFriendsList()

                userDefaults.set(currentTime, forKey: "friendsLastLoad")
            } else {
                setupData(from: friends)
            }
        } catch {
            print(error)
        }
    }

    // MARK: - setupData
    private func setupData(from friends: [RealmUser], with changes: ([Int], [Int], [Int])? = nil) {
        let oldFriends = self.friends
        let oldGrouppedFriends = self.grouppedFriends
        let friends = RealmUser.realmToUser(from: friends)

        self.friends = friends
        self.grouppedFriends = self.groupFriends()

        let grouppedFriends = self.grouppedFriends

        if let changes = changes {
            DispatchQueue.global().async { [weak self] in
                let deletions = IndexCalculator.getIndexes(from: oldFriends, in: oldGrouppedFriends, with: changes.0)
                let insertions = IndexCalculator.getIndexes(from: friends, in: grouppedFriends, with: changes.1)
                let reloads = IndexCalculator.getIndexes(from: oldFriends, in: oldGrouppedFriends, with: changes.2)

                if oldGrouppedFriends.count != self?.grouppedFriends.count {
                    let deletionIndexSet = deletions.reduce(into: IndexSet(), { $0.insert($1.section) })
                    let insertionIndexSet = insertions.reduce(into: IndexSet(), { $0.insert($1.section) })

                    DispatchQueue.main.async {
                        self?.tableView.beginUpdates()

                        self?.tableView.deleteSections(deletionIndexSet, with: .none)
                        self?.tableView.insertSections(insertionIndexSet, with: .none)
                        self?.tableView.reloadRows(at: reloads, with: .none)

                        self?.tableView.endUpdates()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.tableView.beginUpdates()

                        self?.tableView.deleteRows(at: deletions, with: .none)
                        self?.tableView.insertRows(at: insertions, with: .none)
                        self?.tableView.reloadRows(at: reloads, with: .none)

                        self?.tableView.endUpdates()
                    }
                }
            }
        } else {
            self.tableView.reloadData()
        }

        self.setupAlphabetView()
    }

    // MARK: - setupAlphabetView
    private func setupAlphabetView() {
        alphabetControl?.removeFromSuperview()

        if grouppedFriends.count == 0 { return }

        let customFrame = CGRect.zero

        alphabetControl = FriendsAlphabetView(frame: customFrame)
        alphabetControl?.addTarget(self, action: #selector(characterChanged), for: .valueChanged)

        self.grouppedFriends.forEach { self.alphabetControl?.characters.append($0.character) }

        guard let alphabetView = alphabetControl, let tabBarView = tabBarController?.view else { return }

        tabBarView.addSubview(alphabetView)

        NSLayoutConstraint.activate([
            tabBarView.centerYAnchor.constraint(equalTo: alphabetView.centerYAnchor, constant: 0),
            tabBarView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: alphabetView.trailingAnchor, constant: 0)
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

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let friendsPhotoCollectionVC = storyboard.instantiateViewController(withIdentifier: "FriendsPhotoCollectionVC")

        prepare(for: friendsPhotoCollectionVC, at: tableView.indexPathForSelectedRow)

        alphabetControl?.removeFromSuperview()
        
        navigationController?.pushViewController(friendsPhotoCollectionVC, animated: true)
    }

    // MARK: - characterChanged
    @objc func characterChanged() {
        guard let section = grouppedFriends.firstIndex(where: { $0.character == alphabetControl?.selectedCharacter })
        else { return }

        let indexPath = IndexPath(row: 0, section: section)

        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }

    // MARK: - prepareForPushViewControllerAtSender
    private func prepare(for pushViewController: UIViewController, at sender: IndexPath?) {
        guard
            let indexPath = sender,
            let friendPhotoVC = pushViewController as? FriendPhotosCollectionViewController
        else { return }

        friendPhotoVC.userId = grouppedFriends[indexPath.section].users[indexPath.row].id
        try? RealmPhoto.deleteData(by: friendPhotoVC.userId)
    }

    // MARK: - groupFriends
    func groupFriends() -> [GrouppedFriends] {
        var result = [GrouppedFriends]()

        guard let friends = friends else { return [GrouppedFriends]() }

        for friend in friends {
            guard let character: Character = friend.lastName.first else { continue }

            if let currentCharacter = result.firstIndex(where: { $0.character == character }) {
                result[currentCharacter].users.append(friend)
            } else {
                result.append(GrouppedFriends(character: character, users: [friend]))
            }
        }

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
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Removing the bottom separator from the last cell of a section
        if indexPath.row == grouppedFriends[indexPath.section].users.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            guard let width = alphabetControl?.bounds.width else { return }

            cell.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: tableView.bounds.minX + width)
        }
    }

    // MARK: - cellForRowAt
    // Configure cell by section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell",
                                                 for: indexPath) as? FriendsTableViewCell

        cell?.friendImage?.image = nil
        let friend = self.grouppedFriends[indexPath.section].users[indexPath.row]

        guard let imageURL = URL(string: friend.avatar) else { return UITableViewCell() }

        DispatchQueue.global().async { [weak cell] in
            let image = UIImage.fetchImage(at: imageURL)

            DispatchQueue.main.async { [weak cell] in
                cell?.friendImage?.image = image
            }
        }

        cell?.friendName?.text = "\(friend.firstName) \(friend.lastName)"

        return cell ?? UITableViewCell()
    }

    // MARK: - heightForRowAt
    // Automatic cell height calculation
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

