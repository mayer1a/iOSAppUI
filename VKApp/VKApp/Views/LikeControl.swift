//
//  LikeControl.swift
//  VKApp
//
//  Created by Artem Mayer on 04.04.2022.
//

import UIKit

class LikeControl: UIControl {

    @IBOutlet weak var likeLabel: UILabel?
    @IBOutlet weak var hearImage: UIImageView?

    private var likeCounter: Int = 0

    override func awakeFromNib() {
        likeLabel?.textColor = .white
        hearImage?.tintColor = .white
    }

    override var isSelected: Bool {
        didSet {

            guard oldValue != isSelected else { return }
            
            hearImage?.image = isSelected ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")

            hearImage?.tintColor = isSelected ? .systemRed : .white
            likeLabel?.textColor = isSelected ? .systemRed : .white

            likeCounter = isSelected ? likeCounter + 1 : likeCounter - 1

            likeLabel?.text = String(likeCounter)
        }
    }

}
