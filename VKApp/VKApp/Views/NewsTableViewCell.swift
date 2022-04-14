//
//  NewsTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 09.04.2022.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsAuthorAvatar: CircularPreviewImageView?
    @IBOutlet weak var newsAuthorFullName: UILabel?
    @IBOutlet weak var newsPostingDate: UILabel?
    @IBOutlet weak var newsText: UILabel?
    @IBOutlet weak var newsImagesView: UIView?
    @IBOutlet weak var newLikeButton: UIButton?
    @IBOutlet weak var newsCommentButton: UIButton?
    @IBOutlet weak var newsShareButton: UIButton?
    @IBOutlet weak var newsNumberOfViews: UILabel?
    @IBOutlet weak var newsPhotoImageView: PreviewScaledImageView?

}
