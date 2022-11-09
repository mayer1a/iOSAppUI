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
    private var imageCachingService: ImageCachingService?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCachingService = ImageCachingService(from: self.tableView)
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
        headerView.backgroundColor = #colorLiteral(red: 0.8990648985, green: 0.8991654515, blue: 0.9022777677, alpha: 1)

        return headerView
    }

    // MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String?
        let currentNews = news[indexPath.section]
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section) - 1

        switch indexPath.row {
            case 0, numberOfRows:
                cellIdentifier = requiredCellIdentifier(for: indexPath.row, lastIndex: numberOfRows)
            default:
                cellIdentifier = optionalCellIdentifier(by: currentNews.postType, for: indexPath.row - 1)
        }

        guard
            let cellIdentifier = cellIdentifier,
            let newsCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        else { return UITableViewCell() }
        
        (newsCell as? NewsUsersInteractionCell)?.delegate = self
        (newsCell as? NewsUsersInteractionCell)?.cellId = indexPath
        (newsCell as? NewsAuthorDateTimeCell)?.imageCachingService = imageCachingService
        (newsCell as? NewsAuthorDateTimeCell)?.indexPath = indexPath
        (newsCell as? NewsImageCell)?.imageCachingService = imageCachingService
        (newsCell as? NewsImageCell)?.indexPath = indexPath
        (newsCell as? NewsProtocol)?.setup(news: currentNews)

        return newsCell
    }

    // MARK: - willDisplayCell
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard
                self?.news[indexPath.section].newsBody.isViewed == false,
                let interactionCell = cell as? NewsUsersInteractionCell,
                let oldViewsCount = self?.news[indexPath.section].newsBody.viewsCount
            else { return }

            let newViewsCount = oldViewsCount + 1
            let convertViewsCount = String(newViewsCount)

            self?.news[indexPath.section].newsBody.viewsCount = newViewsCount
            self?.news[indexPath.section].newsBody.isViewed = true

            DispatchQueue.main.async {
                if indexPath == interactionCell.cellId {
                    interactionCell.newsViewsLabel?.text = convertViewsCount
                }
            }
        }
    }

    // MARK: - setupData
    private func setupData() {
        DispatchQueue.global().async { [weak self] in
            SessionHelper.shared.fetchNewsfeed { news in
                self?.news = news

                DispatchQueue.main.async {
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
}

// MARK: - NewsInteractionProtocol
extension NewsTableViewController: NewsInteractionProtocol {

    // MARK: - newsLikeButtonDidTapped
    func newsLikeButtonDidTapped(_ isLiked: Bool?, by indexPath: IndexPath?) {
        guard
            let isLiked = isLiked,
            let indexPath = indexPath,
            let oldLikesCount = news[indexPath.section].newsBody.likesCount
        else { return }

        news[indexPath.section].newsBody.isLiked = isLiked ? 1 : 0
        news[indexPath.section].newsBody.likesCount = isLiked ? oldLikesCount + 1 : oldLikesCount - 1

        let indexPaths = [indexPath]
        self.tableView.reloadRows(at: indexPaths, with: .none)
    }
}
