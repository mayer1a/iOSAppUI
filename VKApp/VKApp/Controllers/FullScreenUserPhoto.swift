//
//  FullScreenUserPhoto.swift
//  VKApp
//
//  Created by Artem Mayer on 18.04.2022.
//

import UIKit

// MARK: - UIViewController
class FullScreenUserPhoto: UIViewController {

    // MARK: - Direction
    private enum Direction {
        case left
        case right
        case nonDirection
    }

    @IBOutlet weak var nextUserPhoto: UIImageView?
    @IBOutlet weak var displayedUserPhoto: UIImageView?
    
    var photos = [Photo]()
    var currentPhotoIndex = Int()
    var startImage: UIImage?

    private var direction: Direction? = .nonDirection
    private var isDarken = false

    private lazy var animator: UIViewPropertyAnimator? = {
        return UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
    }()

    private var nextPhotoIndex: Int? {
        let nextIndex = currentPhotoIndex + 1

        return nextIndex < photos.count ? nextIndex : nil
    }

    private var previousPhotoIndex: Int? {
        let previousIndex = currentPhotoIndex - 1

        return previousIndex >= 0 ? previousIndex : nil
    }

    private var displayedPhotoImageView: UIImageView? {
        guard let displayedUserPhoto = displayedUserPhoto, let nextUserPhoto = nextUserPhoto else { return nil }

        return displayedUserPhoto.isHidden ? nextUserPhoto : displayedUserPhoto
    }

    private var hiddenPhotoImageView: UIImageView? {
        guard let displayedUserPhoto = displayedUserPhoto, let nextUserPhoto = nextUserPhoto else { return nil }

        return displayedUserPhoto.isHidden ? displayedUserPhoto : nextUserPhoto
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
            self.setupImageView()
        }
    }

    // MARK: - photoImagePanned
    @objc private func photoImagePanned(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .began: setupAnimations(recognizer)
            case .changed: animationWillChange(recognizer)
            case .ended: endAnimation(recognizer)
            default: break
        }
    }

    // MARK: - photoDidTapped
    @objc private func photoDidTapped() {
        if isDarken {
            lightenBackground()
        } else {
            darkenBackground()
        }

        isDarken.toggle()
    }

    // MARK: - lightenBackground
    private func lightenBackground() {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0) { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                self?.view.layer.backgroundColor = UIColor(named: "backgroundColor")?.cgColor
                self?.navigationController?.navigationBar.isHidden = false

                self?.displayedPhotoImageView?.backgroundColor = UIColor(named: "backgroundColor")
                self?.hiddenPhotoImageView?.backgroundColor = UIColor(named: "backgroundColor")
            }
        }
    }

    // MARK: - darkenBackground
    private func darkenBackground() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.navigationController?.navigationBar.isHidden = true
            self?.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            self?.displayedPhotoImageView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            self?.hiddenPhotoImageView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    // MARK: - setupAnimations
    private func setupAnimations(_ recognizer: UIPanGestureRecognizer) {
        guard let animator = animator else { return }

        animator.stopAnimation(true)
        animator.finishAnimation(at: .current)

        if recognizer.translation(in: self.view).x < 0 {
            swipeToLeft()
        } else {
            swipeToRight()
        }
    }

    // MARK: - swipeToLeft
    private func swipeToLeft() {
        guard let nextPhotoIndex = nextPhotoIndex else { return }
        
        direction = .left

        let hiddenPhotoImageView = hiddenPhotoImageView
        let displayedPhotoImageView = displayedPhotoImageView
        hiddenPhotoImageView?.image = nil

        setupScaledImage(by: nextPhotoIndex, bounds: self.view.bounds) { image in
            hiddenPhotoImageView?.image = image
        }

        hiddenPhotoImageView?.frame = getNewHiddenImageViewFrame()
        hiddenPhotoImageView?.isHidden = false

        // Transform scale animation
        animator?.addAnimations {
            displayedPhotoImageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }

        // Translation animation with delay
        animator?.addAnimations({ [weak self] in
            guard let self = self else { return }

            hiddenPhotoImageView?.frame.origin.x = self.view.frame.origin.x
            displayedPhotoImageView?.frame.origin.x = -(self.view.bounds.maxX)

            self.view.layoutIfNeeded()
        }, delayFactor: 0.3)

        animator?.addCompletion { [weak self] position in
            switch position {
                case .end:
                    guard let nextPhotoIndex = self?.nextPhotoIndex else { return }

                    displayedPhotoImageView?.isHidden = true
                    displayedPhotoImageView?.transform = .identity

                    self?.currentPhotoIndex = nextPhotoIndex
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
        guard let previousPhotoIndex = previousPhotoIndex else { return }

        direction = .right

        let hiddenPhotoImageView = hiddenPhotoImageView
        let displayedPhotoImageView = displayedPhotoImageView
        hiddenPhotoImageView?.image = nil

        setupScaledImage(by: previousPhotoIndex, bounds: self.view.bounds) { image in
            hiddenPhotoImageView?.image = image
        }

        hiddenPhotoImageView?.frame = getNewHiddenImageViewFrame()
        hiddenPhotoImageView?.isHidden = false
        hiddenPhotoImageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Transform scale animation
        animator?.addAnimations { [weak self] in
            guard
                let originX = self?.view.frame.origin.x,
                let width = self?.view.frame.width,
                let maxX = self?.view.bounds.maxX
            else { return }

            hiddenPhotoImageView?.frame.origin.x = originX + (width / 10)
            displayedPhotoImageView?.frame.origin.x = maxX

            self?.view.layoutIfNeeded()
        }

        // Translation animation with delay
        animator?.addAnimations({ hiddenPhotoImageView?.transform = .identity }, delayFactor: 0.7)

        animator?.addCompletion { [weak self] position in
            switch position {
                case .end:
                    guard let previousPhotoIndex = self?.previousPhotoIndex else { return }

                    displayedPhotoImageView?.isHidden = true

                    self?.currentPhotoIndex = previousPhotoIndex
                case .start:
                    hiddenPhotoImageView?.isHidden = true
                    hiddenPhotoImageView?.transform = .identity
                default:
                    break
            }
        }

        animator?.pauseAnimation()
    }

    // MARK: - getNewHiddenImageViewFrame
    private func getNewHiddenImageViewFrame() -> CGRect {
        guard var frame = hiddenPhotoImageView?.frame else { return CGRect.zero }

        frame.origin.x = direction == .left ? self.view.bounds.width : -self.view.bounds.width
        frame.origin.y = self.view.frame.origin.y
        frame.size = self.view.frame.size

        return frame
    }

    // MARK: - animationDidChage
    private func animationWillChange(_ recognizer: UIPanGestureRecognizer) {
        guard let animator = animator else { return }

        let translationX = recognizer.translation(in: self.view).x
        var fraction = translationX / (self.view.frame.size.width)

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

    // MARK: - setupImageView
    private func setupImageView() {
        self.displayedPhotoImageView?.frame = self.view.frame
    }

    // MARK: - setupView
    private func setupView() {
        self.displayedUserPhoto?.image = startImage

        setupScaledImage(by: currentPhotoIndex, bounds: self.view.bounds) { [weak self] scaledFetchedImage in
            self?.displayedUserPhoto?.image = scaledFetchedImage
        }

        let size = self.view.frame.size
        self.displayedUserPhoto?.frame = self.view.frame
        self.displayedUserPhoto?.center = CGPoint(x: size.width / 2, y: size.height / 2)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoDidTapped))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(photoImagePanned(_:)))

        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)

        animator?.scrubsLinearly = false

        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "backgroundColor")
        self.navigationController?.navigationBar.isTranslucent = true
    }

    // MARK: - setupDisplayedImage
    private func setupScaledImage(by displayedIndex: Int, bounds: CGRect, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard
                let imagePath = self?.photos[displayedIndex].originalSizeUrl,
                let imageUrl = URL(string: imagePath),
                let image = UIImage.fetchImage(at: imageUrl),
                let scaledImage = UIImage.resizeImage(bounds: bounds, image: image)
            else { return }

            DispatchQueue.main.async {
                completion(scaledImage)
            }
        }
    }
}
