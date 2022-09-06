//
//  InteractiveTransitionDriven.swift
//  VKApp
//
//  Created by Artem Mayer on 27.04.2022.
//

import UIKit

// MARK: - UIPercentDrivenInteractiveTransition
final class InteractiveTransitionDriven: UIPercentDrivenInteractiveTransition {
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    var viewControllerWillPopped: UIViewController? {
        didSet {
            let panRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeDidPan(_:)))
            panRecognizer.edges = .left
            
            viewControllerWillPopped?.view.addGestureRecognizer(panRecognizer)
        }
    }
    
    // MARK: - screenEdgeDidPan
    @objc private func screenEdgeDidPan(_ panRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            hasStarted = true
            viewControllerWillPopped?.navigationController?.popViewController(animated: true)
        case .changed:
            guard let viewWillPopped = viewControllerWillPopped?.view else { return }
            
            let transition = panRecognizer.translation(in: viewWillPopped)
            let relativeTransition = transition.y / viewWillPopped.bounds.width
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
