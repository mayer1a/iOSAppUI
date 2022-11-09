//
//  PhotoView.swift
//  VKApp
//
//  Created by Artem Mayer on 04.04.2022.
//

import UIKit

// MARK: - UIView
final class PhotoView: UIView {
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.isOpaque = false
        self.layer.cornerRadius = self.frame.width / 2
        
        // Add tap gesture recognizer to PhotoView
        let gesture = UITapGestureRecognizer(target: self, action: #selector(photoViewDidTapped))
        gesture.numberOfTapsRequired = 1

        self.addGestureRecognizer(gesture)
    }
    
    // MARK: - @objc friendPhotoViewDidTapped
    // Photo preivew animation configuration
    @objc func photoViewDidTapped() {
        let animationStart = CASpringAnimation(keyPath: "transform")
        
        animationStart.duration = 1
        animationStart.fromValue = self.layer.transform
        animationStart.toValue = CATransform3DMakeScale(0.75, 0.75, 1)
        animationStart.damping = 3.4
        animationStart.stiffness = 50.0
        animationStart.mass = 1
        animationStart.initialVelocity = 10.0
        animationStart.fillMode = .both
        animationStart.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animationStart.isRemovedOnCompletion = true
        
        // Complition block for return photo preview
        CATransaction.setCompletionBlock {
            let animationEnd = CASpringAnimation(keyPath: "transform")
            
            animationEnd.duration = 1
            animationEnd.fromValue = CATransform3DMakeScale(0.75, 0.75, 1)
            animationEnd.toValue = CATransform3DMakeScale(1, 1, 1)
            animationEnd.damping = 3.4
            animationEnd.stiffness = 50.0
            animationEnd.mass = 1
            animationEnd.initialVelocity = 10.0
            animationEnd.fillMode = .both
            animationEnd.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animationEnd.isRemovedOnCompletion = true
            
            self.layer.add(animationEnd, forKey: nil)
        }
        
        self.layer.add(animationStart, forKey: nil)
    }
}
