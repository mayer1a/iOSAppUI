//
//  FriendsTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit

// MARK: - UITableViewCell
final class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var friendImage: CircularPreviewImageView?
    @IBOutlet weak var friendName: UILabel?
    var userId: Int?
}
