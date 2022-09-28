//
//  AnimationNavigationController.swift
//  VKApp
//
//  Created by Artem Mayer on 27.04.2022.
//

import UIKit

// MARK: - UINavigationController
final class AnimationNavigationController: UINavigationController {
    var interactiveTransition = InteractiveTransitionDriven()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

// MARK: - UINavigationControllerDelegate
extension AnimationNavigationController: UINavigationControllerDelegate {

    // MARK: - navigationFromVcToVc
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        switch operation {
        case .push:
            interactiveTransition.viewControllerWillPopped = toVC

            return TransitionAnimation(isPresenting: true)
        case .pop:
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewControllerWillPopped = toVC
            }
            
            return TransitionAnimation(isPresenting: false)
        default:
            return nil
        }
    }

    // MARK: - interactionControllerFor
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
}
