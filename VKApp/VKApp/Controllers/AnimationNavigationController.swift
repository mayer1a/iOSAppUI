//
//  AnimationNavigationController.swift
//  VKApp
//
//  Created by Artem Mayer on 27.04.2022.
//

import UIKit


// MARK: - UINavigationController

class AnimationNavigationController: UINavigationController {

    var interactiveTransition: InteractiveTransitionDriven?

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
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        switch operation {
        case .push:
            interactiveTransition = InteractiveTransitionDriven(viewControllerWillPopped: toVC)

            return TransitionAnimation(isPresenting: true)

        case .pop:
            return TransitionAnimation(isPresenting: false)

        default:
            return nil
        }

    }


    // MARK: - interactionControllerFor

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        guard let interactiveTransition = interactiveTransition else { return nil }

        return interactiveTransition.hasStarted ? interactiveTransition : nil

    }

}
