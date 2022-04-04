//
//  GroupTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 31.03.2022.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupImage: CircularPreviewImageView?
    @IBOutlet weak var groupName: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
