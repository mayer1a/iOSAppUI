//
//  FriendsTableViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: CircularPreviewImageView?
    @IBOutlet weak var friendName: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
