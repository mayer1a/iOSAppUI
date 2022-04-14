//
//  NewsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 09.04.2022.
//

import UIKit

class NewsTableViewController: UITableViewController {

    var displayedNews: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        displayedNews = News.list

        tableView.sectionHeaderTopPadding = 0
    }


    // MARK: - numberOfRowsInSection

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    // MARK: - numberOfSections

    override func numberOfSections(in tableView: UITableView) -> Int {
        return displayedNews.count
    }


    // MARK: - heightForRowAt

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


    // MARK: - heightForHeaderInSection

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell

        let news = displayedNews[indexPath.section]

        guard let userAvatarName = news.user.avatar,
              let userAvatarPath = Bundle.main.path(forResource: userAvatarName, ofType: "jpg"),
              let userAvatar = cell?.newsAuthorAvatar?.resizedImage(at: userAvatarPath, for: imageSize()),
              let newsText = news.text,
              let newsPhotoName = news.photos?.first?.name,
              let newsPhotoPath = Bundle.main.path(forResource: newsPhotoName, ofType: "jpg"),
              let newsPhoto = cell?.newsPhotoImageView?.resizedImage(at: newsPhotoPath, for: imageSize()) else {
            return UITableViewCell()
        }

        cell?.newsAuthorAvatar?.image = userAvatar
        cell?.newsAuthorFullName?.text = "\(news.user.name) \(news.user.surname)"
        cell?.newsPostingDate?.text = news.postingDate
        cell?.newsText?.text = newsText
        cell?.newsPhotoImageView?.image = newsPhoto
        cell?.newLikeButton?.titleLabel?.text = String(news.numberOfLikes)
        cell?.newsCommentButton?.titleLabel?.text = String(news.numbersOfComments)
        cell?.newsShareButton?.titleLabel?.text = String(news.numbersOfShares)
        cell?.newsNumberOfViews?.text = String(news.numberOfViews)

        return cell ?? UITableViewCell()
    }


    // MARK: - imageSize

    // Scale based on screen size
    func imageSize() -> CGSize {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        return view.bounds.size.applying(scale)
    }

}
