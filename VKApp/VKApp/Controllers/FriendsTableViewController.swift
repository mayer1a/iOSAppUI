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
    private let operationQueue = OperationQueue()
    private var imageCachingService: ImageCachingService?
    private var friends: [User]?
    private var alphabetControl: FriendsAlphabetView?
    private var realmNotification: NotificationToken?
    var grouppedFriends = [GrouppedFriends]()
    
    private lazy var cloudView: CloudView? = {
        let cloudView = CloudView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 100)))
        cloudView.translatesAutoresizingMaskIntoConstraints = false

        return cloudView
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCachingService = ImageCachingService(from: self.tableView)
        
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
            guard self.view.window != nil else { return }
            
            self.setupAlphabetView()
        }
    }
    
    // MARK: - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // At the end of the timer, the animation ends and perform segue to the next controller
        Timer.scheduledTimer(timeInterval: 3,
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
                let request = SessionHelper.shared.getFriendsRequest
                let fetchDataOperation = FetchDataOperation(request: request)
                let asyncParseOperation = AsyncParseDataOperation<User>()
                let saveRealmOperation = SaveRealmOperation<User>()
                
                asyncParseOperation.addDependency(fetchDataOperation)
                saveRealmOperation.addDependency(asyncParseOperation)
                
                operationQueue.qualityOfService = .userInteractive
                operationQueue.addOperation(fetchDataOperation)
                operationQueue.addOperation(asyncParseOperation)
                operationQueue.addOperation(saveRealmOperation)
                
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
        
        guard let changes = changes
        else {
            self.tableView.reloadData()
            return
        }

        DispatchQueue.global().async { [weak self] in
            let deletions = IndexHelper.getIndexes(from: oldFriends, in: oldGrouppedFriends, with: changes.0)
            let insertions = IndexHelper.getIndexes(from: friends, in: grouppedFriends, with: changes.1)
            let reloads = IndexHelper.getIndexes(from: oldFriends, in: oldGrouppedFriends, with: changes.2)

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
        
        self.setupAlphabetView()
    }
    
    // MARK: - setupAlphabetView
    private func setupAlphabetView() {
        alphabetControl?.removeFromSuperview()

        guard !grouppedFriends.isEmpty else { return }
        
        alphabetControl = FriendsAlphabetView(frame: CGRect.zero)
        alphabetControl?.addTarget(self, action: #selector(characterChanged), for: .valueChanged)

        let grouppedFriends = self.grouppedFriends

        DispatchQueue.global().async { [weak self] in
            let characters = grouppedFriends.map { $0.character }

            DispatchQueue.main.async { [weak self] in
                guard
                    let alphabetView = self?.alphabetControl,
                    let tabBarView = self?.tabBarController?.view
                else { return }

                alphabetView.characters = characters
                tabBarView.addSubview(alphabetView)

                NSLayoutConstraint.activate([
                    tabBarView.centerYAnchor.constraint(equalTo: alphabetView.centerYAnchor, constant: 0),
                    tabBarView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: alphabetView.trailingAnchor,
                                                                             constant: 0)
                ])
            }
        }
    }
    
    // MARK: - @objc stopAnimation
    @objc private func stopAnimation() {
        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            self?.cloudView?.alpha = 0.1
        }
        
        self.cloudView?.removeAnimation()
        self.cloudView?.removeFromSuperview() // delete

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let friendsPhotoCollectionVC = storyboard.instantiateViewController(withIdentifier: "FriendsPhotoCollectionVC")
        
        prepare(for: friendsPhotoCollectionVC, at: tableView.indexPathForSelectedRow)
        
        alphabetControl?.removeFromSuperview() // delete
        
        navigationController?.pushViewController(friendsPhotoCollectionVC, animated: true)
    }
    
    // MARK: - characterChanged
    @objc private func characterChanged() {
        guard let section = alphabetControl?.selectedIndex else { return }
        
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
    private func groupFriends() -> [GrouppedFriends] {
        var result = [GrouppedFriends]()
        
        friends?.forEach { friend in
            guard let character: Character = friend.lastName.first else { return }
            
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
        headerView.contentView.backgroundColor = UIColor(named: "sectionBackgroundColor")
        
        return headerView
    }
    
    // MARK: - cellForRowAt
    // Configure cell by section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell",
                                                 for: indexPath) as? FriendsTableViewCell
        
        let friend = self.grouppedFriends[indexPath.section].users[indexPath.row]

        cell?.friendImage?.image = UIImage(named: "NonAvatar")
        
        imageCachingService?.getImage(at: indexPath, by: friend.avatar) { image in
            cell?.friendImage?.image = image
        }
        
        cell?.friendName?.text = "\(friend.firstName) \(friend.lastName)"

        return cell ?? UITableViewCell()
    }
    
    // MARK: - heightForRowAt
    // Automatic cell height calculation
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(93)
    }
}

