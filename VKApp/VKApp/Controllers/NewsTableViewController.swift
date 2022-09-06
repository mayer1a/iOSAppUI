//
//  NewsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 09.04.2022.
//

import UIKit

// MARK: - UITableViewController
final class NewsTableViewController: UITableViewController {
    var news: [News] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }

    // MARK: - numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var newsBlocksCount = 2

        switch news[section].postType {
        case .text, .image, .video, .audio: newsBlocksCount += 1
        case .textImage, .textVideo, .textAudio, .imageVideo, .imageAudio, .videoAudio: newsBlocksCount += 2
        case .textImageVideo, .textImageAudio, .textVideoAudio, .imageVideoAudio: newsBlocksCount += 3
        case .textImageVideoAudio: newsBlocksCount += 4
        case .none: break
        }
        
        return newsBlocksCount
    }

    // MARK: - numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }

    // MARK: - heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - heightForHeaderInSection
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat(0) : CGFloat(10)
    }

    // MARK: - viewForHeaderInSection
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Configurated custom view for header between cells
        if section == 0 { return nil }

        let headerView = UIView()
        headerView.backgroundColor = .systemGray2
        headerView.alpha = 0.4

        return headerView
    }

    // MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentNews = news[indexPath.section]
        let cellIdentifier: String?
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section) - 1

        switch indexPath.row {
        case 0, numberOfRows: cellIdentifier = requiredCellIdentifier(for: indexPath.row, lastIndex: numberOfRows)
        default: cellIdentifier = optionalCellIdentifier(by: currentNews.postType, for: indexPath.row - 1)
        }

        guard
            let cellIdentifier = cellIdentifier,
            let newsCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        else { return UITableViewCell() }

        (newsCell as? NewsProtocol)?.setup(news: currentNews)

        return newsCell
    }
    
    // MARK: - setupData
    private func setupData() {
        DispatchQueue.global().async { [weak self] in
            SessionManager.shared.fetchNewsfeed { news in
                DispatchQueue.main.async {
                    self?.news = news
                    self?.tableView.reloadData()
                }
            }
        }

        tableView.sectionHeaderTopPadding = CGFloat(0)
    }

    // MARK: requiredCellIdentifier
    private func requiredCellIdentifier(for row: Int, lastIndex: Int) -> String? {
        switch row {
        case 0: return "NewsAuthorDatetime"
        case lastIndex: return "NewsUsersInteraction"
        default: return nil
        }
    }

    // MARK: optionalCellIdentifier
    private func optionalCellIdentifier(by type: News.Kind?, for index: Int) -> String? {
        switch type {
        case .some(_): return type?.rawValue[index]
        case .none: return nil
        }
    }

//    private func dataValidityCheck() {
//
//        do {
//            let groups = try RealmGroup.restoreData()
//            let userDefaults = UserDefaults.standard
//            let currentTime = Int(Date().timeIntervalSince1970)
//
//            if currentTime - userDefaults.integer(forKey: "newsfeedLastLoad") > 3_600 || groups.isEmpty {
//                SessionManager.shared.getNewsfeed { news in
//
//                }
//
//                userDefaults.set(currentTime, forKey: "newsfeedLastLoad")
//            } else {
//                self.setupData(from: groups)
//            }
//        } catch {
//            print(error)
//        }
//    }
}
