//
//  ShowFullPhotoPresentAnimator.swift
//  VKApp
//
//  Created by Artem Mayer on 16.11.2022.
//

import UIKit

// MARK: - ShowFullPhotoPresentAnimator
final class ShowFullPhotoPresentAnimator: NSObject {
    private var isPresenting: Bool
    private let animationDuration: TimeInterval
    private var backToCellFrame: CGRect?

    init(isPresenting: Bool, duration: TimeInterval = 1.0) {
        self.isPresenting = isPresenting
        self.animationDuration = duration
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension ShowFullPhotoPresentAnimator: UIViewControllerAnimatedTransitioning {

    // MARK: - transitionDuration
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    // MARK: - animateTransition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentAnimation(using: transitionContext)
        } else {
            dismissAnimation(using: transitionContext)
        }
        
        isPresenting.toggle()
    }

    // MARK: - presentAnimation
    func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from),
            let fromCellViewRect = (fromViewController as? ViewPresentable)?.photoCellViewRect(),
            let tabBar = fromViewController.tabBarController?.tabBar
        else { return }

        transitionContext.containerView.addSubview(toViewController.view)

        toViewController.view.frame = fromCellViewRect

        self.backToCellFrame = toViewController.view.frame

        let finalFrame = transitionContext.finalFrame(for: toViewController)

        toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(0)
        (toViewController as? FullScreenUserPhoto)?.displayedUserPhoto?.backgroundColor = (toViewController as? FullScreenUserPhoto)?.displayedUserPhoto?.backgroundColor?.withAlphaComponent(0)

        tabBar.isHidden = false
        UIView.transition(with: tabBar, duration: 0.7, options: .transitionCrossDissolve, animations: nil)

        UIView.animateKeyframes(withDuration: animationDuration, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7) {
                toViewController.view.frame = finalFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(1)
                (toViewController as? FullScreenUserPhoto)?.displayedUserPhoto?.backgroundColor = (toViewController as? FullScreenUserPhoto)?.displayedUserPhoto?.backgroundColor?.withAlphaComponent(1)
            }
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }

    // MARK: - dismissAnimation
    func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from),
            let tabBar = toViewController.tabBarController?.tabBar,
            let photoIndex = (fromViewController as? FullScreenUserPhoto)?.currentPhotoIndex,
            let startFrame = (toViewController as? ViewPresentable)?.photoCellViewRect(of: photoIndex)
        else { return }

        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        toViewController.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: tabBar.frame.origin.y)

        tabBar.isHidden = false
        UIView.transition(with: tabBar, duration: 0.7, options: .transitionCrossDissolve, animations: nil)
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 1) {
                fromViewController.view.frame = startFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7) {
                fromViewController.view.backgroundColor = fromViewController.view.backgroundColor?.withAlphaComponent(0)
                (fromViewController as? FullScreenUserPhoto)?.displayedUserPhoto?.backgroundColor = (fromViewController as? FullScreenUserPhoto)?.displayedUserPhoto?.backgroundColor?.withAlphaComponent(0)
            }
        } completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                fromViewController.removeFromParent()
            }

            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
