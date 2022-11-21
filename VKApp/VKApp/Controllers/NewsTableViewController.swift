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
    private var isLoadingNews: Bool = false
    private var selectedIndex: IndexPath?
    private let backgroundHeaderColor = {
        UIColor(named: "newsTableViewBackgroundColor")
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCachingService = ImageCachingService(from: self.tableView)
        setupData()
        setupRefreshControl()
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
        // Expand selected cell
        if selectedIndex == indexPath {
            return UITableView.automaticDimension
        }

        switch news[indexPath.section].postType {
            case .image, .imageAudio, .imageVideo, .imageVideoAudio:
                if indexPath.row == 1 {
                    return getImageCellSize(tableView, indexPath)
                }
            case .textImage, .textImageAudio, .textImageVideo, .textImageVideoAudio:
                if indexPath.row == 1 {
                    return getTextCellSize(tableView, indexPath)
                }

                if indexPath.row == 2 {
                    return getImageCellSize(tableView, indexPath)
                }
            case .text, .textVideo, .textAudio, .textVideoAudio:
                if indexPath.row == 1 {
                    return getTextCellSize(tableView, indexPath)
                }
            case .some(_), .none: break
        }

        // If the current cell is author information return fixed 92 pt size
        return indexPath.row == 0 ? CGFloat(92) : UITableView.automaticDimension
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
        headerView.backgroundColor = backgroundHeaderColor

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
        (newsCell as? NewsTextCell)?.cellId = indexPath.section
        (newsCell as? NewsTextCell)?.showMoreButton?.tag = indexPath.section
        (newsCell as? NewsTextCell)?.showMoreButton?.addTarget(self, action: #selector(showMoreText), for: .touchUpInside)
        (newsCell as? NewsProtocol)?.setup(news: currentNews)

        return newsCell
    }

    // MARK: - willDisplayCell
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell as? NewsTextCell)?.newsText?.isOversizeLabel() == true {
            (cell as? NewsTextCell)?.showMoreButton?.isHidden = false
        } else {
            (cell as? NewsTextCell)?.showMoreButton?.isHidden = true
        }
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
        tableView.sectionHeaderTopPadding = CGFloat(0)

        DispatchQueue.global().async { [weak self] in
            SessionHelper.shared.fetchNewsfeed { news in
                self?.news = news

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - requiredCellIdentifier
    private func requiredCellIdentifier(for row: Int, lastIndex: Int) -> String? {
        switch row {
            case 0: return "NewsAuthorDatetime"
            case lastIndex: return "NewsUsersInteraction"
            default: return nil
        }
    }

    // MARK: - optionalCellIdentifier
    private func optionalCellIdentifier(by type: News.Kind?, for index: Int) -> String? {
        switch type {
            case .some(_): return type?.rawValue[index]
            case .none: return nil
        }
    }

    // MARK: - getTextCellSize
    /// If the current cell is text that exceed 200 pt, return fixed 200 pt
    private func getTextCellSize(_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat {
        guard
            let cellLabel = (self.tableView(tableView, cellForRowAt: indexPath) as? NewsTextCell)?.newsText,
            cellLabel.isOversizeLabel() == true
        else { return UITableView.automaticDimension }

        return cellLabel.newsLabelSize()
    }

    // MARK: - getImageCellSize
    /// If the current cell is an image, return the aspect rate size
    private func getImageCellSize(_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat {
        guard let aspectRatio = news[indexPath.section].newsBody.images[0]?.aspectRatio
        else { return UITableView.automaticDimension }

        return tableView.bounds.width * aspectRatio
    }

    // MARK: - newsRefresh
    @objc private func newsRefresh() {
        refreshControl?.beginRefreshing()

        var lastLoadDate = self.news.first?.newsBody.date ?? Date().timeIntervalSince1970

        DispatchQueue.global().async { [weak self] in
            SessionHelper.shared.fetchNewsfeed(from: lastLoadDate + 1) { news in
                DispatchQueue.main.async { [weak self] in
                    self?.refreshControl?.endRefreshing()
                }

                guard news.count > 0, let oldNews = self?.news else { return }

                lastLoadDate = news.first?.newsBody.date ?? lastLoadDate + 1
                UserDefaults.standard.set(lastLoadDate, forKey: "newsLastLoad")

                self?.news = news + oldNews
                let indexSet = IndexSet(integersIn: 0..<news.count)
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.insertSections(indexSet, with: .automatic)
                }
            }
        }
    }

    // MARK: - showMoreText
    @objc private func showMoreText(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview as? NewsTextCell,
            let indexPath = tableView.indexPath(for: cell)
        else { return }

        if selectedIndex == indexPath {
            let indexPathSection = IndexPath(row: 0, section: selectedIndex!.section)
            tableView.scrollToRow(at: indexPathSection, at: .top, animated: true)

            selectedIndex = nil
            cell.showMoreButton?.setTitle("Показать больше...", for: .normal)
        } else {
            selectedIndex = indexPath
            cell.showMoreButton?.setTitle("Показать меньше", for: .normal)
        }

        tableView.reloadSections(IndexSet(integersIn: indexPath.section..<indexPath.section), with: .automatic)
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

        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension NewsTableViewController: UITableViewDataSourcePrefetching {

    // MARK: - tableViewPrefetchRowsAt
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard
                let self = self,
                let maxSection = indexPaths.map({ $0.section }).max(),
                let nextFrom = UserDefaults.standard.string(forKey: "newsNextFrom"),
                !nextFrom.isEmpty,
                maxSection > self.news.count - 4,
                !self.isLoadingNews
            else { return }

            self.isLoadingNews = true

            SessionHelper.shared.fetchNewsfeed(for: nextFrom) { news in
                let indexSet = IndexSet(integersIn: self.news.count..<self.news.count + news.count)

                DispatchQueue.main.async { [weak self] in
                    self?.news.append(contentsOf: news)
                    self?.tableView.insertSections(indexSet, with: .automatic)
                    self?.isLoadingNews = false
                }
            }
        }
    }

    // MARK: - setupRefreshControl
    private func setupRefreshControl() {
        guard
            let foregroundColor = UIColor(named: "navigationBarButtonTintColor"),
            let backgroundColor = UIColor(named: "newsTableViewBackgroundColor")
        else { return }


        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byClipping

        refreshControl?.tintColor = foregroundColor
        refreshControl?.attributedTitle = NSAttributedString(string: "Обновление", attributes: [
            .foregroundColor : foregroundColor,
            .backgroundColor : backgroundColor,
            .paragraphStyle : paragraphStyle
        ])
        refreshControl?.addTarget(self, action: #selector(newsRefresh), for: .valueChanged)
    }
}
