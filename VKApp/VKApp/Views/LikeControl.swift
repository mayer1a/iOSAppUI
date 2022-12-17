//
//  LikeControl.swift
//  VKApp
//
//  Created by Artem Mayer on 04.04.2022.
//

import UIKit

// MARK: - UIControl
final class LikeControl: UIControl {
    @IBOutlet weak var likeLabel: UILabel?
    @IBOutlet weak var heartImage: UIImageView?
    
    private var likeCounter: Int = 0
    private let foregroundColor = UIColor.photoLikesForegroundColor
    
    override var isSelected: Bool {
        didSet {
            guard oldValue != isSelected else { return }
            
            heartImage?.image = isSelected ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            heartImage?.tintColor = isSelected ? .systemRed : foregroundColor
            likeLabel?.textColor = isSelected ? .systemRed : foregroundColor
            
            likeCounter = isSelected ? likeCounter + 1 : likeCounter - 1
            
            likeLabel?.text = String(likeCounter)
        }
    }
    
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        likeLabel?.textColor = foregroundColor
        heartImage?.tintColor = foregroundColor
    }
    
    // MARK: - setupLikesCounter
    func setupLikesCounter(equal likeCount: Int) {
        self.likeCounter = likeCount
    }
}
