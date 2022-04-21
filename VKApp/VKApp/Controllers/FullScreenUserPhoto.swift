//
//  FullScreenUserPhoto.swift
//  VKApp
//
//  Created by Artem Mayer on 18.04.2022.
//

import UIKit
import func AVFoundation.AVMakeRect


class FullScreenUserPhoto: UIViewController {

    // MARK: - Direction

    private enum Direction {
        case left
        case right
        case nonDirection
    }

    @IBOutlet weak var nextUserPhoto: UIImageView?
    @IBOutlet weak var displayedUserPhoto: UIImageView?

    var userPhotos: [Photo] = []
    var showPhotoIndex = Int()

    private var direction: Direction? = .nonDirection

    private lazy var animator: UIViewPropertyAnimator? = {
        return UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
    }()

    private var nextPhotoIndex: Int? {
        let nextIndex = showPhotoIndex + 1

        return nextIndex < userPhotos.count ? nextIndex : nil
    }

    private var previousPhotoIndex: Int? {
        let previousIndex = showPhotoIndex - 1

        return previousIndex >= 0 ? previousIndex : nil
    }

    private var displayedPhotoImageView: UIImageView? {
        guard let displayedUserPhoto = displayedUserPhoto, let nextUserPhoto = nextUserPhoto else { return nil }

        return [displayedUserPhoto, nextUserPhoto].first(where: { !$0.isHidden })
    }

    private var hiddenPhotoImageView: UIImageView? {
        guard let displayedUserPhoto = displayedUserPhoto, let nextUserPhoto = nextUserPhoto else { return nil }

        return [displayedUserPhoto, nextUserPhoto].first(where: { $0.isHidden })
    }


    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }


    // MARK: - viewWillTransition

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { _ in
            self.setupImageViews()
        }

    }


    // MARK: - photoImagePanned

    @objc private func photoImagePanned(_ recognizer: UIPanGestureRecognizer) {

        switch recognizer.state {
        case .began: setupAnimations(recognizer)

        case .changed: animationWillChange(recognizer)

        case .ended: endAnimation(recognizer)

        default:
            break
        }
    }


    // MARK: - photoDidTapped

    @objc private func photoDidTapped() {

        if self.view.layer.backgroundColor != UIColor.black.cgColor {
            darkenBackground()
        } else {
            lightenBackground()
        }
    }


    // MARK: - lightenBackground

    private func lightenBackground() {

        UIView.animateKeyframes(withDuration: 0.2, delay: 0) { [weak self] in

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self?.view.layer.backgroundColor = UIColor.white.cgColor
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self?.navigationController?.navigationBar.isHidden = false
            }
        }
    }


    // MARK: - darkenBackground

    private func darkenBackground() {

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.navigationController?.navigationBar.isHidden = true
            self?.view.layer.backgroundColor = UIColor.black.cgColor
        }
    }


    // MARK: - setupImageViews

    private func setupImageViews() {

        guard var frame = self.displayedPhotoImageView?.frame,
              let hiddexOriginX = self.hiddenPhotoImageView?.frame.origin.x
        else {
            return
        }

        frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.origin.y
        frame.size = self.view.safeAreaLayoutGuide.layoutFrame.size

        self.displayedPhotoImageView?.frame = frame

        self.displayedPhotoImageView?.center = CGPoint(x: self.view.frame.size.width / 2,
                                                       y: self.view.frame.size.height / 2)

        // Frame setting based on the location of the hidden image view
        if hiddexOriginX <= 0 {

            let origin = CGPoint(x: -self.view.safeAreaLayoutGuide.layoutFrame.width,
                                 y: self.view.safeAreaLayoutGuide.layoutFrame.origin.y)
            let size = self.view.safeAreaLayoutGuide.layoutFrame.size

            self.hiddenPhotoImageView?.frame = CGRect(origin: origin, size: size)

        } else {

            let origin = CGPoint(x: self.view.safeAreaLayoutGuide.layoutFrame.width,
                                 y: self.view.safeAreaLayoutGuide.layoutFrame.origin.y)
            let size = self.view.safeAreaLayoutGuide.layoutFrame.size

            self.hiddenPhotoImageView?.frame = CGRect(origin: origin, size: size)

        }
    }


    // MARK: - setupAnimations

    private func setupAnimations(_ recognizer: UIPanGestureRecognizer) {

        guard let animator = animator else { return }

        animator.stopAnimation(true)
        animator.finishAnimation(at: .current)

        if recognizer.velocity(in: self.view).x < 0 {
            swipeToLeft()
        } else {
            swipeToRight()
        }

    }


    // MARK: - swipeToLeft

    private func swipeToLeft() {

        guard let nextPhotoIndex = nextPhotoIndex,
              var frame = hiddenPhotoImageView?.frame
        else {
            return
        }
        
        direction = .left

        let hiddenPhotoImageView = hiddenPhotoImageView
        let displayedPhotoImageView = displayedPhotoImageView

        frame.origin.x = self.view.bounds.width
        frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.origin.y
        frame.size.width = self.view.safeAreaLayoutGuide.layoutFrame.width

        hiddenPhotoImageView?.frame = frame
        hiddenPhotoImageView?.image = setupDisplayedImage(by: nextPhotoIndex)
        hiddenPhotoImageView?.isHidden = false

        // Transform scale animation
        animator?.addAnimations {
            displayedPhotoImageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }

        // Translation animation with delay
        animator?.addAnimations({ [weak self] in

            guard let self = self else { return }

            hiddenPhotoImageView?.frame.origin.x = self.view.safeAreaLayoutGuide.layoutFrame.origin.x
            displayedPhotoImageView?.frame.origin.x = -(self.view.bounds.maxX)

            self.view.layoutIfNeeded()

        }, delayFactor: 0.3)

        animator?.addCompletion { [weak self] position in

            switch position {
            case .end:

                guard let nextPhotoIndex = self?.nextPhotoIndex else { return }

                displayedPhotoImageView?.isHidden = true
                displayedPhotoImageView?.transform = .identity

                self?.showPhotoIndex = nextPhotoIndex
                self?.view.layoutIfNeeded()

            case .start:

                hiddenPhotoImageView?.isHidden = true

            default:
                break
            }
        }

        animator?.pauseAnimation()
    }


    // MARK: - swipeToRight

    private func swipeToRight() {

        guard let previousPhotoIndex = previousPhotoIndex,
              var frame = hiddenPhotoImageView?.frame
        else {
            return
        }

        direction = .right

        let hiddenPhotoImageView = hiddenPhotoImageView
        let displayedPhotoImageView = displayedPhotoImageView

        frame.origin.x = -self.view.bounds.width
        frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.origin.y
        frame.size.width = self.view.safeAreaLayoutGuide.layoutFrame.width

        hiddenPhotoImageView?.frame = frame
        hiddenPhotoImageView?.image = setupDisplayedImage(by: previousPhotoIndex)
        hiddenPhotoImageView?.isHidden = false
        hiddenPhotoImageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Transform scale animation
        animator?.addAnimations { [weak self] in

            guard let self = self else { return }

            hiddenPhotoImageView?.frame.origin.x = self.view.safeAreaLayoutGuide.layoutFrame.origin.x + (self.view.safeAreaLayoutGuide.layoutFrame.width / 10)
            displayedPhotoImageView?.frame.origin.x = self.view.bounds.maxX

            self.view.layoutIfNeeded()
        }

        // Translation animation with delay
        animator?.addAnimations({

            hiddenPhotoImageView?.transform = .identity

        }, delayFactor: 0.7)

        animator?.addCompletion { [weak self] position in

            switch position {
            case .end:

                guard let previousPhotoIndex = self?.previousPhotoIndex else { return }

                displayedPhotoImageView?.isHidden = true

                self?.showPhotoIndex = previousPhotoIndex

            case .start:

                hiddenPhotoImageView?.isHidden = true
                hiddenPhotoImageView?.transform = .identity

            default:
                break
            }
        }

        animator?.pauseAnimation()

    }


    // MARK: - animationDidChage

    private func animationWillChange(_ recognizer: UIPanGestureRecognizer) {

        guard let animator = animator else { return }

        let translationX = recognizer.translation(in: self.view).x
        var fraction = translationX / (self.view.frame.size.width / 2)

        switch direction {
        case .left where translationX < 0: fraction *= -1

        case .left where translationX >= 0: fraction = 0

        case .right where translationX <= 0: fraction = 0

        default : break
        }

        animator.fractionComplete = fraction

    }


    // MARK: - endAnimation

    private func endAnimation(_ sender: UIPanGestureRecognizer) {

        guard let animator = animator else { return }

        if animator.fractionComplete >= 0.6 {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        } else {
            animator.isReversed.toggle()
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }

    }


    // MARK: - setupView

    private func setupView() {

        displayedUserPhoto?.image = setupDisplayedImage(by: showPhotoIndex)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoDidTapped))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(photoImagePanned(_:)))

        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)

        animator?.scrubsLinearly = false
    }


    // MARK: - setupImage

    private func setupDisplayedImage(by displayedIndex: Int) -> UIImage {

        let diplayedPhotoName = userPhotos[displayedIndex].name

        guard let path = Bundle.main.path(forResource: diplayedPhotoName, ofType: "jpg"),
              let displayedPhoto = resizedImage(at: path)
        else {
            return UIImage()
        }

        return displayedPhoto
    }


    // MARK: - resizedImage

    // Resize photo image
    private func resizedImage(at path: String) -> UIImage? {

        guard let image = UIImage(contentsOfFile: path) else { return nil }

        var rect = AVMakeRect(aspectRatio: image.size, insideRect: self.view.bounds)

        let height = rect.height * 0.75
        let width = rect.width * 0.75
        let size = CGSize(width: width, height: height)

        rect = CGRect(origin: rect.origin, size: size)

        let renderer = UIGraphicsImageRenderer(size: rect.size)

        let renderedImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: rect.size))
        }

        return renderedImage
    }

}
