//
//  FriendPhotosCollectionViewCell.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import UIKit

final class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendPhoto: PreviewScaledImageView?
    @IBOutlet weak var likeControl: LikeControl?

    var photoDidLiked: ((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        likeControl?.addTarget(self, action: #selector(likeControlTapped), for: .touchUpInside)
    }


    // MARK: - likeControlTapped

    @objc private func likeControlTapped() {
        guard let likeControl = likeControl else { return }

        likeControl.isSelected.toggle()
        
        photoDidLiked?(likeControl.isSelected)

        likeControlAnimation(by: likeControl.isSelected)
    }


    // MARK: - likeControlAnimation

    // Setting up and running animation
    private func likeControlAnimation(by isLiked: Bool) {

        if isLiked {
            let heartImageAnimation = CASpringAnimation(keyPath: "transform.scale")
            let likeLabelRotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            let likeLabelTranslateAnimation = CASpringAnimation(keyPath: "transform.translation.y")
            let animationsGroup = CAAnimationGroup()

            // heartImage animation
            heartImageAnimation.duration = 0.4
            heartImageAnimation.fromValue = 1.0
            heartImageAnimation.toValue = 1.12
            heartImageAnimation.autoreverses = true
            heartImageAnimation.repeatCount = 2
            heartImageAnimation.initialVelocity = 0.5
            heartImageAnimation.damping = 0.8
            heartImageAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

            // likeLabel rotate animation
            likeLabelRotateAnimation.duration = 0.4
            likeLabelRotateAnimation.fromValue = 0.0
            likeLabelRotateAnimation.toValue = CGFloat.pi * 2
            likeLabelRotateAnimation.fillMode = .both
            likeLabelRotateAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            // likeLabel translate animation
            likeLabelTranslateAnimation.duration = 0.6
            likeLabelTranslateAnimation.toValue = (likeControl?.likeLabel?.frame.origin.y ?? 100) - 10
            likeLabelTranslateAnimation.autoreverses = true
            likeLabelTranslateAnimation.repeatCount = 1
            likeLabelTranslateAnimation.initialVelocity = 0.5
            likeLabelTranslateAnimation.damping = 0.8
            likeLabelTranslateAnimation.fillMode = .both
            likeLabelTranslateAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            animationsGroup.duration = likeLabelRotateAnimation.duration + likeLabelTranslateAnimation.duration
            animationsGroup.animations = [likeLabelRotateAnimation, likeLabelTranslateAnimation]

            likeControl?.heartImage?.layer.add(heartImageAnimation, forKey: nil)
            likeControl?.likeLabel?.layer.add(animationsGroup, forKey: nil)

        } else {
            let heartImageAnimation = CASpringAnimation(keyPath: "transform.translation.x")
            let likeLabelScaleAnimation = CABasicAnimation(keyPath: "transform.scale")

            // heartImage animation
            heartImageAnimation.duration = 0.5
            heartImageAnimation.toValue = -14.0
            heartImageAnimation.repeatCount = 1
            heartImageAnimation.autoreverses = true
            heartImageAnimation.initialVelocity = 0
            heartImageAnimation.stiffness = 54.0
            heartImageAnimation.mass = 1
            heartImageAnimation.damping = 5
            heartImageAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

            // likeLabel rotate animation
            likeLabelScaleAnimation.duration = 0.5
            likeLabelScaleAnimation.toValue = CGAffineTransform(scaleX: 0, y: 0)
            likeLabelScaleAnimation.repeatCount = 1
            likeLabelScaleAnimation.autoreverses = true
            likeLabelScaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            likeControl?.heartImage?.layer.add(heartImageAnimation, forKey: nil)
            likeControl?.likeLabel?.layer.add(likeLabelScaleAnimation, forKey: nil)
        }

    }
}
