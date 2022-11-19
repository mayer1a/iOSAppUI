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
            let fromViewCell = (transitionContext.viewController(forKey: .from) as? ViewPresentable)?.photoCellView
        else { return }

        let startFrame = fromViewCell.convert(fromViewController.view.safeAreaLayoutGuide.layoutFrame,
                                              to: fromViewController.view)

        transitionContext.containerView.addSubview(toViewController.view)

        toViewController.view.frame = CGRect(origin: startFrame.origin, size: fromViewCell.frame.size)

        self.backToCellFrame = toViewController.view.frame

        let finalFrame = transitionContext.finalFrame(for: toViewController)

        toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(0)
        toViewController.view.subviews.forEach {
            $0.backgroundColor = $0.backgroundColor?.withAlphaComponent(0)
        }
        toViewController.view.alpha = 0

        UIView.animateKeyframes(withDuration: animationDuration, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                toViewController.view.frame = finalFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 1) {
                toViewController.view.alpha = 1
                toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(1)
                toViewController.view.subviews.forEach {
                    $0.backgroundColor = $0.backgroundColor?.withAlphaComponent(1)
                }
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
            let startFrame = backToCellFrame
        else { return }

        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        UIView.animateKeyframes(withDuration: animationDuration, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                fromViewController.view.frame = startFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.9) {
                fromViewController.view.alpha = 0
                fromViewController.view.backgroundColor = fromViewController.view.backgroundColor?.withAlphaComponent(0)
                fromViewController.view.subviews.forEach {
                    $0.backgroundColor = $0.backgroundColor?.withAlphaComponent(0)
                }
            }
        } completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                fromViewController.removeFromParent()
            }

            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
