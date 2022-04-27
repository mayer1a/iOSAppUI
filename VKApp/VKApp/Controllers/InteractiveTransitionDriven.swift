//
//  InteractiveTransitionDriven.swift
//  VKApp
//
//  Created by Artem Mayer on 27.04.2022.
//

import UIKit

class InteractiveTransitionDriven: UIPercentDrivenInteractiveTransition {

    var viewControllerWillPopped: UIViewController

    var hasStarted: Bool = false
    var shouldFinish: Bool = false

    init(viewControllerWillPopped: UIViewController) {
        self.viewControllerWillPopped = viewControllerWillPopped

        super.init()

        let panRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeDidPan(_:)))
        panRecognizer.edges = .left

        viewControllerWillPopped.view.addGestureRecognizer(panRecognizer)
    }


    // MARK: - screenEdgeDidPan
    
    @objc private func screenEdgeDidPan(_ panRecognizer: UIScreenEdgePanGestureRecognizer) {

        switch panRecognizer.state {
        case .began:
            hasStarted = true
            viewControllerWillPopped.navigationController?.popViewController(animated: true)

        case .changed:
            let transition = panRecognizer.translation(in: viewControllerWillPopped.view)
            let relativeTransition = transition.y / viewControllerWillPopped.view.bounds.width
            let progress = max(0, min(1, relativeTransition))

            shouldFinish = progress > 0.5

            update(progress)

        case .cancelled:
            hasStarted = false

            cancel()

        case .ended:
            hasStarted = false
            
            shouldFinish ? finish() : cancel()

        default:
            break
        }

    }

}
