//
//  SearchGroupTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit

final class SearchGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupImage: CircularPreviewImageView?
    @IBOutlet weak var groupName: UILabel?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
