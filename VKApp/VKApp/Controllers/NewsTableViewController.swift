//
//  NewsTableViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 09.04.2022.
//

import UIKit

class NewsTableViewController: UITableViewController {

    var displayedNews: [NewsMock] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell

        let news = displayedNews[indexPath.section]

//        guard
//            let newsText = news.text,
//            let userAvatarName = news.user.avatar,
//            let userAvatarPath = Bundle.main.path(forResource: userAvatarName, ofType: "jpg"),
//            let userAvatar = cell?.newsAuthorAvatar?.resizedImage(at: userAvatarPath, for: imageSize()),
//            let newsPhotoName = news.photos?.first?.name,
//            let newsPhotoPath = Bundle.main.path(forResource: newsPhotoName, ofType: "jpg")
//        else {
//            let newsPhoto = cell?.newsPhotoImageView?.resizedImage(at: newsPhotoPath, for: imageSize()) else {
//            return UITableViewCell()
//        }

        let numberOfLikes = news.numberOfLikes != nil ? String(news.numberOfLikes!) : nil
        let numberOfComments = news.numberOfComments != nil ? String(news.numberOfComments!) : nil
        let numberOfShares = news.numberOfShares != nil ? String(news.numberOfShares!) : nil
        let numberOfViews = news.numberOfViews != nil ? String(news.numberOfViews!) : nil

//        cell?.newsAuthorAvatar?.image = userAvatar
//        cell?.newsPhotoImageView?.image = newsPhoto
        cell?.newsAuthorFullName?.text = "\(news.user.firstName) \(news.user.lastName)"
        cell?.newsPostingDate?.text = news.postingDate
        cell?.newsText?.text = news.text
        cell?.newsLikeButton?.setTitle(numberOfLikes, for: .normal)
        cell?.newsCommentButton?.setTitle(numberOfComments, for: .normal)
        cell?.newsShareButton?.setTitle(numberOfShares, for: .normal)
        cell?.newsNumberOfViews?.text = numberOfViews

        return cell ?? UITableViewCell()
    }

    
    // MARK: - setupData

    private func setupData() {
        displayedNews = NewsMock.news

        tableView.sectionHeaderTopPadding = CGFloat(0)
    }

}
