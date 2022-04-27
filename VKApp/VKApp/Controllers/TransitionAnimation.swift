//
//  TransitionAnimation.swift
//  VKApp
//
//  Created by Artem Mayer on 26.04.2022.
//

import UIKit


class TransitionAnimation: NSObject {

    private let isPresenting: Bool
    private let animationDuration: TimeInterval

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        self.animationDuration = 1
    }

}


// MARK: - UIViewControllerAnimatedTransitioning

extension TransitionAnimation: UIViewControllerAnimatedTransitioning {

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

    }


    // MARK: - presentAnimation

    func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)

        toViewController.view.layer.position = setAnchorPoint(CGPoint(x: 1, y: 0), by: containerView)
        toViewController.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        toViewController.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        toViewController.view.layer.cornerRadius = 150
        toViewController.view.layer.masksToBounds = true
        toViewController.view.layer.borderWidth = 1
        toViewController.view.layer.borderColor = UIColor.systemBlue.cgColor

        UIView.animateKeyframes(withDuration: animationDuration,
                                delay: 0,
                                options: []) {

            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.65) {
                toViewController.view.transform = CGAffineTransform(rotationAngle: 0)
            }

            UIView.addKeyframe(withRelativeStartTime: 0.65,
                               relativeDuration: 0.35) {
                toViewController.view.layer.cornerRadius = 0
            }

        } completion: { isComplete in

            toViewController.view.layer.masksToBounds = false
            toViewController.view.layer.borderWidth = 0
            toViewController.view.layer.borderColor = UIColor.clear.cgColor

            transitionContext.completeTransition(isComplete)
        }

    }


    // MARK: - dismissAnimation

    func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            return
        }

        let containerView = transitionContext.containerView

        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        fromViewController.view.layer.position = setAnchorPoint(CGPoint(x: 1, y: 0), by: containerView)
        fromViewController.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        fromViewController.view.layer.cornerRadius = 0
        fromViewController.view.layer.masksToBounds = true
        fromViewController.view.layer.borderWidth = 1
        fromViewController.view.layer.borderColor = UIColor.systemBlue.cgColor

        UIView.animateKeyframes(withDuration: animationDuration,
                                delay: 0,
                                options: []) {

            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.35) {
                fromViewController.view.layer.cornerRadius = 150
            }

            UIView.addKeyframe(withRelativeStartTime: 0.35,
                               relativeDuration: 0.65) {
                fromViewController.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            }

        } completion: { isComplete in

            if transitionContext.transitionWasCancelled {

                fromViewController.view.layer.masksToBounds = false
                fromViewController.view.layer.borderWidth = 0
                fromViewController.view.layer.borderColor = UIColor.clear.cgColor

            }
            
            transitionContext.completeTransition(isComplete && !transitionContext.transitionWasCancelled)

        }

    }


    // MARK: - setAnchorPoint

    // Сhanging the pivot point of the view
    private func setAnchorPoint(_ point: CGPoint, by containerView: UIView) -> CGPoint {

        var position = containerView.layer.position
        var newPoint = CGPoint(x: containerView.bounds.size.width * point.x,
                               y: containerView.bounds.size.height * point.y)

        var oldPoint = CGPoint(x: containerView.bounds.size.width * containerView.layer.anchorPoint.x,
                               y: containerView.bounds.size.height * containerView.layer.anchorPoint.y);

        newPoint = newPoint.applying(containerView.transform)
        oldPoint = oldPoint.applying(containerView.transform)

        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y

        return position

    }

}
