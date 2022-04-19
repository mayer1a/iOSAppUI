//
//  FullScreenUserPhoto.swift
//  VKApp
//
//  Created by Artem Mayer on 18.04.2022.
//

import UIKit
import func AVFoundation.AVMakeRect

class FullScreenUserPhoto: UIViewController {

    @IBOutlet weak var nextUserPhoto: UIImageView?
    @IBOutlet weak var displayedUserPhoto: UIImageView?


    var userPhotos: [Photo] = []
    var showPhotoIndex = Int()
    var animator: UIViewPropertyAnimator?
    var animationProgress = CGFloat(0)

    var displayedPhotoImageView: UIImageView? {
        guard let displayedUserPhoto = displayedUserPhoto, let nextUserPhoto = nextUserPhoto else { return nil }

        return [displayedUserPhoto, nextUserPhoto].first(where: { !$0.isHidden })
    }

    var hiddenPhotoImageView: UIImageView? {
        guard let displayedUserPhoto = displayedUserPhoto, let nextUserPhoto = nextUserPhoto else { return nil }

        return [displayedUserPhoto, nextUserPhoto].first(where: { $0.isHidden })
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayedUserPhoto?.image = setupImageView(by: showPhotoIndex)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(photoDidTapped))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(photoImagePanned(_:)))

        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(gesture)

    }


    // MARK: - viewWillTransition

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate { [weak self] _ in
            guard
                let self = self,
                var frame = self.displayedPhotoImageView?.frame
            else {
                return
            }

            frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.origin.y
            frame.size = self.view.safeAreaLayoutGuide.layoutFrame.size

            self.displayedPhotoImageView?.frame = frame

            self.displayedPhotoImageView?.center = CGPoint(x: self.view.frame.size.width / 2,
                                                           y: self.view.frame.size.height / 2)

            if self.hiddenPhotoImageView?.frame.origin.x ?? 0 <= 0 {
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

    }


    // MARK: - photoImagePanned

    @objc private func photoImagePanned(_ sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began:

            guard showPhotoIndex + 1 < userPhotos.count else { return }

            let hiddenPhotoImageView = hiddenPhotoImageView
            let displayedPhotoImageView = displayedPhotoImageView

            animator?.stopAnimation(true)
            animator?.finishAnimation(at: .end)

            showPhotoIndex += 1

            self.view.layoutIfNeeded()

            hiddenPhotoImageView?.image = setupImageView(by: showPhotoIndex)
            hiddenPhotoImageView?.frame.origin.x = self.view.bounds.width
            hiddenPhotoImageView?.isHidden = false

            animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut)

            guard let fractionComplete = animator?.fractionComplete else { return }

            animationProgress = fractionComplete

            animator?.addAnimations {

                UIView.animateKeyframes(withDuration: 0.5,
                                        delay: 0,
                                        options: []) {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                        displayedPhotoImageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    }


                }
            }

            animator?.addAnimations({

                hiddenPhotoImageView?.frame.origin.x = 0
                displayedPhotoImageView?.frame.origin.x = -(self.view.bounds.width)
                self.view.setNeedsLayout()

                UIView.animateKeyframes(withDuration: 1,
                                        delay: 0.5,
                                        options: []) {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                        self.view.layoutIfNeeded()
                    }
                }
            }, delayFactor: 0.5)

            animator?.addCompletion { _ in
                displayedPhotoImageView?.isHidden = true
                displayedPhotoImageView?.transform = .identity
            }

            animator?.pauseAnimation()

        case .changed:

            let translationX = sender.translation(in: self.view).x
            var fraction = translationX / (self.view.frame.size.width / 2)

            if translationX < 0 {
                fraction = abs(fraction)
            }

            animator?.fractionComplete = fraction + animationProgress

        case .ended:
            animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            //            if (animator?.fractionComplete ?? 0) > 0.5 {
            //                animator?.continueAnimation(withTimingParameters: UISpringTimingParameters(dampingRatio: 0.6), durationFactor: 1)
            //            } else {
            //                animator?.isReversed = true
            //                animator?.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            //            }

        default:
            break
        }
    }


    // MARK: - photoDidTapped

    @objc private func photoDidTapped() {

        if self.view.layer.backgroundColor != UIColor.black.cgColor {
            UIView.animate(withDuration: 0.2) {
                self.navigationController?.navigationBar.isHidden = true
                self.view.layer.backgroundColor = UIColor.black.cgColor
            }
        } else {
            UIView.animateKeyframes(withDuration: 0.2,
                                    delay: 0,
                                    options: []){
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.view.layer.backgroundColor = UIColor.white.cgColor
                }

                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.navigationController?.navigationBar.isHidden = false
                }
            }
        }
    }


    // MARK: - setupImage

    private func setupImageView(by: Int) -> UIImage {

        let diplayedPhotoName = userPhotos[showPhotoIndex].name

        guard
            let path = Bundle.main.path(forResource: diplayedPhotoName, ofType: "jpg"),
            let displayedPhoto = resizedImage(at: path, for: imageSize())
        else {
            return UIImage()
        }

        return displayedPhoto
    }


    // MARK: - resizedImage

    // Resize photo image
    private func resizedImage(at path: String, for size: CGSize) -> UIImage? {
        guard let image = UIImage(contentsOfFile: path) else { return nil }

        let rect = AVMakeRect(aspectRatio: image.size, insideRect: self.view.bounds)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        
        let renderedImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: rect.size))
        }

        return renderedImage
    }


    // MARK: - imageSize

    // Scale based on screen size
    private func imageSize() -> CGSize {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        return self.view.bounds.size.applying(scale)
    }
    

}
