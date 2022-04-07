//
//  FriendPhotosCollectionViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit

class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendPhoto: SquarePreviewImageView?
    @IBOutlet weak var likeControl: LikeControl?

    override func awakeFromNib() {
        super.awakeFromNib()

        likeControl?.addTarget(self, action: #selector(likeControlTapped), for: .touchUpInside)
    }

    @objc
    func likeControlTapped() {
        guard let likeControl = likeControl else { return }

        likeControl.isSelected.toggle()
    }
}
